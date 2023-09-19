
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

      order.update!(
        pickup_start_time: args[:pickup_start_time] || order.pickup_start_time,
        pickup_end_time: args[:pickup_end_time] || order.pickup_end_time,
        quantity: args[:quantity] || order.quantity,
        status: "preparing",
        subtotal: subtotal,
        total: subtotal * 1.13
      )

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