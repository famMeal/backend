
module Mutations::Order
  class UpdateAllOrdersStatus < Mutations::BaseMutation
    argument :from_status, String, required: true
    argument :to_status, String, required: true
    argument :restaurant_id, ID, required: true

    field :errors, [String], null: false
    field :orders, [Types::OrderType], null: true

    def resolve(**args)
      orders = Order.by_restaurant_and_status(args[:restaurant_id], args[:from_status])
     
      orders.update_all(status: args[:to_status])
    
      orders_result = Order.by_restaurant_and_status(args[:restaurant_id], args[:to_status])
      { orders: orders_result, errors: [] }
    rescue StandardError => e
      { errors: [e.message] }
    end
  end
end