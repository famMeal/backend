
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
      @order = Order.find(args[:order_id])
      
      update_status(args[:status]) if args[:status]
      order.pickup_start_time = args[:pickup_start_time] if args[:pickup_start_time]
      order.pickup_end_time = args[:pickup_end_time] if args[:pickup_end_time]

      if args[:quantity]
        order.assign_attributes(
          quantity: args[:quantity],
          subtotal: calculate_subtotal(args[:quantity], order.meal_id),
          total: subtotal * 1.13
        )  
      end

      order.save!

      { order: order, errors: [] }
    rescue StandardError => e
      { errors: [e.message] }
    end

    def calculate_subtotal(quantity, meal_id)
      @subtotal ||= Meal.find(meal_id).price * quantity
    end

    def update_status(status)
      previous_status = order.status
      
      if status == "completed" && previous_status == "picked_up"
        order.status = "completed-restaurant"
      elsif status == "completed"
        order.status = "completed-client"
      else
        order.status = status
      end
    end

    attr_reader :subtotal, :order
  end
end