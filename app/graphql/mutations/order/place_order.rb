
module Mutations::Order
  class PlaceOrder < Mutations::BaseMutation
    argument :pickup_start_time, String, required: false
    argument :pickup_end_time, String, required: false
    argument :quantity, Integer, required: false
    argument :order_id, ID, required: true

    field :errors, [String], null: false
    field :order, Types::OrderType, null: true
    field :payment_intent, String, null: true
    field :ephemeral_key, String, null: true
    field :customer_id, String, null: true
    field :setup_intent, String, null: true

    def resolve(**args)
      @args = args
      @order = Order.find(args[:order_id])
      setting = order.restaurant.restaurant_setting

      raise StandardError.new("Choose either tip percentage or amount, not both") if args[:tip_percentage] && args[:tip_amount]
      raise StandardError.new("Sorry we don't have enough #{order.meal.name} available! #{setting.quantity_available} meals left") if setting.quantity_available < order.quantity

      ActiveRecord::Base.transaction do
        setting.with_lock do
          setting.update_columns(quantity_available: setting.quantity_available - order.quantity)

          order.update_columns(
            pickup_start_time: args[:pickup_start_time] || order.pickup_start_time,
            pickup_end_time: args[:pickup_end_time] || order.pickup_end_time,
            quantity: order.quantity,
            order_placed_at: DateTime.now
          )

          create_stripe_payment_intent!
        end
      end

      {
        order: order,
        ephemeral_key: @payment_info[:ephemeral_key],
        payment_intent: @payment_info[:payment_intent],
        customer_id: @payment_info[:customer_id],
        setup_intent: @payment_info[:setup_intent],
        errors: []
      }
    rescue StandardError => e
      { errors: [e.message] }
    end

    attr_reader :order, :args, :payment_info

    private

    def create_stripe_payment_intent!
      customer_stripe_account_id = order.user.customer_stripe_account_id
    
      # Create or retrieve the customer in the main Stripe account
      customer = if customer_stripe_account_id.present?
        Stripe::Customer.retrieve(customer_stripe_account_id)
      else
        Stripe::Customer.create(email: order.user.email)
      end
    
      # Update the user's customer_stripe_account_id if it was just created
      order.user.update!(customer_stripe_account_id: customer['id']) unless customer_stripe_account_id.present?
    
      restaurant_stripe_account_id = order.restaurant.stripe_account_id

      # Create or retrieve the corresponding customer in the connected account
      connected_customer_id = ConnectStripeAccount.where(user: order.user.id, restaurant: order.restaurant).first&.stripe_account_id || create_connected_customer(customer['id'], restaurant_stripe_account_id)
     
      # NOT WORKING YET: Create a SetupIntent to save the card to the main customer account
      setup_intent = Stripe::SetupIntent.create({
        customer: customer['id'],
        payment_method_types: ['card'],
        usage: 'off_session'
      })

      ephemeral_key = Stripe::EphemeralKey.create(
        { customer: connected_customer_id }, 
        { stripe_account: restaurant_stripe_account_id, stripe_version: '2024-04-10' }
      )
    
      payment_intent = Stripe::PaymentIntent.create({
        amount: (order.total * 100).to_i,
        currency: 'cad',
        customer: connected_customer_id,
        automatic_payment_methods: { enabled: true }
      }, { stripe_account: restaurant_stripe_account_id })

      @payment_info = { 
        payment_intent: payment_intent['client_secret'], 
        ephemeral_key: ephemeral_key["secret"], 
        customer_id: connected_customer_id, 
        setup_intent: setup_intent['client_secret'] 
      }
    end

    def create_connected_customer(main_customer_id, connected_account_id)
      customer = Stripe::Customer.create(
        { 
          email: order.user.email, 
          metadata: { main_customer_id: main_customer_id }
        }, 
        { stripe_account: connected_account_id }
      )

      ConnectStripeAccount.create!(user: order.user, restaurant: order.restaurant, stripe_account_id: customer['id'])

      customer['id']
    end
  end
end