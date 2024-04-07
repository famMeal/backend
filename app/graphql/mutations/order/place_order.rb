
module Mutations::Order
  class PlaceOrder < Mutations::BaseMutation
    argument :pickup_start_time, String, required: false
    argument :pickup_end_time, String, required: false
    argument :quantity, Integer, required: false
    argument :order_id, ID, required: true

    field :errors, [String], null: false
    field :order, Types::OrderType, null: true

    def resolve(**args)
      @args = args
      @order = Order.find(args[:order_id])

      ActiveRecord::Base.transaction do
        setting = order.restaurant.restaurant_setting
       
        setting.with_lock do
          raise StandardError.new("Sorry we don't have enough #{order.meal.name} available! #{setting.quantity_available} meals left") if setting.quantity_available < args[:quantity]

          setting.update_columns(quantity_available: setting.quantity_available - args[:quantity])

          order.update_columns(
            pickup_start_time: args[:pickup_start_time] || order.pickup_start_time,
            pickup_end_time: args[:pickup_end_time] || order.pickup_end_time,
            quantity: args[:quantity] || order.quantity,
            order_placed_at: DateTime.now,
            status: "preparing",
            subtotal: subtotal,
            total: subtotal * 1.13
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