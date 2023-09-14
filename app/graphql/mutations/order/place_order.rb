
module Mutations::Order
  class PlaceOrder < Mutations::BaseMutation
    argument :pickup_start_time, String, required: false
    argument :pickup_end_time, String, required: false
    argument :tip_amount, Float, required: false
    argument :quantity, Integer, required: false
    argument :order_id, ID, required: true

    field :errors, [String], null: false
    field :order, Types::OrderType, null: true

    def resolve(**args)
      @order = Order.find(args[:order_id])

      order.update!(
        pickup_start_time: args[:pickup_start_time] || order.pickup_start_time,
        pickup_end_time: args[:pickup_end_time] || order.pickup_end_time,
        quantity: args[:quantity] || order.quantity,
        status: "preparing",
        tip_amount: args[:tip_amount] || order.tip_amount,
        subtotal: calculate_subtotal(args[:quantity]),
        total: (subtotal * 1.13) + (args[:tip_amount] || order.tip_amount)
      )

      { order: order, errors: [] }
    rescue StandardError => e
      { errors: [e.message] }
    end

    def calculate_subtotal(new_quantity)
      @subtotal ||= new_quantity ? order.meal.price * new_quantity : order.subtotal
    end

    attr_reader :order, :subtotal
  end
end