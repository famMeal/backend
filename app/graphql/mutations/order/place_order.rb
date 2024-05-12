
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

    def resolve(**args)
      Stripe.api_key = ENV['STRIPE_SECRET_KEY']

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
            order_placed_at: DateTime.now,
            status: "preparing"
          )
          
          create_stripe_payment_intent!
        end
      end

      { 
        order: order, 
        ephemeral_key: @payment_info[:ephemeral_key], 
        payment_intent: @payment_info[:payment_intent], 
        customer_id: @payment_info[:customer_id], 
        errors: [] 
      }
    rescue StandardError => e
      { errors: [e.message] }
    end

    attr_reader :order, :args, :payment_info

    private

    def create_stripe_payment_intent!
      customer = Stripe::Customer.create(
        { email: order.user.email }, 
        { stripe_account: order.restaurant.stripe_account_id }
      )
    
      ephemeral_key = Stripe::EphemeralKey.create(
        { customer: customer['id'] }, 
        { stripe_account: order.restaurant.stripe_account_id, stripe_version: '2024-04-10' }
      )

      payment_intent = Stripe::PaymentIntent.create({
        amount: (order.total * 100).to_i,
        currency: 'cad',
        customer: customer['id'],
        automatic_payment_methods: { enabled: true },
        application_fee_amount: ((order.total * 0.02) * 100).to_i,
      }, { stripe_account: order.restaurant.stripe_account_id })

      @payment_info = { payment_intent: payment_intent["id"], ephemeral_key: ephemeral_key["id"], customer_id: customer['id'] }
    end
  end
end