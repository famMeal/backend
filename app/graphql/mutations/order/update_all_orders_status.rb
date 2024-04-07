
module Mutations::Order
  class UpdateAllOrdersStatus < Mutations::BaseMutation
    argument :from_status, Types::FilterObjects::OrderStatusField, required: true
    argument :to_status, Types::FilterObjects::OrderStatusField, required: true
    argument :restaurant_id, ID, required: true

    field :errors, [String], null: false
    field :orders, [Types::OrderType], null: true

    def resolve(**args)
      orders = Order.by_restaurant_and_status(args[:restaurant_id], args[:from_status])
      previous_status = args[:from_status]
      
      new_status = if args[:to_status] == "completed" && previous_status == "picked_up"
        "completed_restaurant"
      elsif args[:to_status] == "completed"
        "completed_client"
      else
        args[:to_status]
      end

      orders.update_all(status: new_status)
    
      orders_result = Order.by_restaurant_and_status(args[:restaurant_id], args[:to_status])
      { orders: orders_result, errors: [] }
    rescue StandardError => e
      { errors: [e.message] }
    end
  end
end