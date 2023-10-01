
module Mutations::Order
  class UpdateOrder < Mutations::BaseMutation
    argument :order_id, ID, required: true
    argument :status, String, required: false
    argument :quantity, Integer, required: false
    argument :pickup_start_time, String, required: false
    argument :pickup_end_time, String, required: false

    field :errors, [String], null: false
    field :order, Types::OrderType, null: true

    def resolve(**args)
      order = Order.find(args[:order_id])
      
      attributes_to_update = {}
      attributes_to_update.merge!({ status: args[:status] }) if args[:status]
      attributes_to_update.merge!({ pickup_start_time: args[:pickup_start_time] }) if args[:pickup_start_time]
      attributes_to_update.merge!({ pickup_end_time: args[:pickup_end_time] }) if args[:pickup_end_time]

      if args[:quantity]
        attributes_to_update.merge!({
          quantity: args[:quantity],
          subtotal: calculate_subtotal(args[:quantity], order.meal_id),
          total: subtotal * 1.13
        })  
      end

      order.update!(attributes_to_update)

      { order: order, errors: [] }
    rescue StandardError => e
      { errors: [e.message] }
    end

    def calculate_subtotal(quantity, meal_id)
      @subtotal ||= Meal.find(meal_id).price * quantity
    end

    attr_reader :subtotal
  end
end