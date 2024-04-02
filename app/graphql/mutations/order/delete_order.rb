
module Mutations::Order
  class DeleteOrder < Mutations::BaseMutation
    argument :order_id, ID, required: true

    field :errors, [String], null: false
    field :order, Types::OrderType, null: true

    def resolve(**args)
      order = Order.find(args[:order_id])
      
      order.destroy!

      { order: order, errors: [] }
    rescue StandardError => e
      { errors: [e.message] }
    end
  end
end