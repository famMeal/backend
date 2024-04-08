
module Mutations::Order
  class PlaceOrder < Mutations::BaseMutation
    argument :pickup_start_time, String, required: false
    argument :pickup_end_time, String, required: false
    argument :quantity, Integer, required: false
    argument :order_id, ID, required: true
    argument :tip_amount, Float, required: false
    argument :tip_percentage, Integer, required: false

    field :errors, [String], null: false
    field :order, Types::OrderType, null: true

    def resolve(**args)
      @args = args
      @order = Order.find(args[:order_id])
      setting = order.restaurant.restaurant_setting

      raise StandardError.new("Choose either tip percentage or amount, not both") if args[:tip_percentage] && args[:tip_amount]
      raise StandardError.new("Sorry we don't have enough #{order.meal.name} available! #{setting.quantity_available} meals left") if setting.quantity_available < args[:quantity]

      ActiveRecord::Base.transaction do
        setting.with_lock do
          setting.update_columns(quantity_available: setting.quantity_available - args[:quantity])

          total_without_tip = subtotal * 1.13
          tip_amount = args[:tip_amount] || total_without_tip * (args[:tip_percentage].to_d / 100.00)
     
          order.update_columns(
            pickup_start_time: args[:pickup_start_time] || order.pickup_start_time,
            pickup_end_time: args[:pickup_end_time] || order.pickup_end_time,
            quantity: args[:quantity] || order.quantity,
            order_placed_at: DateTime.now,
            status: "preparing",
            subtotal: subtotal,
            total: total_without_tip + tip_amount,
            tip_amount: tip_amount,
            tip_percentage: args[:tip_percentage] || nil
          )
        end
      end

      { order: order, errors: [] }
    rescue StandardError => e
      { errors: [e.message] }
    end

    def subtotal
      @subtotal ||= args[:quantity] ? order.meal.price * args[:quantity] : order.subtotal
    end

    attr_reader :order, :args
  end
end