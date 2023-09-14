
module Mutations::Order
  class UpdateOrderStatus < Mutations::BaseMutation
    argument :order_id, ID, required: true
    argument :status, String, required: true

    field :errors, [String], null: false
    field :order, Types::OrderType, null: true

    def resolve(**args)
      order = Order.find(args[:order_id])
      
      order.update!(status: args[:status])

      { order: order, errors: [] }
    rescue StandardError => e
      { errors: [e.message] }
    end
  end
end