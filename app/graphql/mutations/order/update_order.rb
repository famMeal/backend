
module Mutations::Order
  class UpdateOrder < Mutations::BaseMutation
    argument :order_id, ID, required: true
    argument :status, Types::FilterObjects::OrderStatusField, required: false
    argument :quantity, Integer, required: false
    argument :pickup_start_time, String, required: false
    argument :pickup_end_time, String, required: false
    argument :tip_amount, Float, required: false
    argument :tip_percentage, Integer, required: false

    field :errors, [String], null: false
    field :order, Types::OrderType, null: true

    def resolve(**args)
      @order = Order.find(args[:order_id])
      @subtotal = Meal.find(order.meal_id).price * args[:quantity]

      update_status(args[:status]) if args[:status]
      
      order.pickup_start_time = args[:pickup_start_time] if args[:pickup_start_time]
      order.pickup_end_time = args[:pickup_end_time] if args[:pickup_end_time]

      total_without_tip = subtotal * 1.13
      tip_amount = args[:tip_amount] || total_without_tip * (args[:tip_percentage].to_d / 100.00)
 
      if args[:quantity]
        order.assign_attributes(
          quantity: args[:quantity],
          subtotal: subtotal,
          total: total_without_tip + tip_amount,
          tip_amount: tip_amount,
          tip_percentage: args[:tip_percentage] || nil
        )  
      end

      order.save!

      { order: order, errors: [] }
    rescue StandardError => e
      { errors: [e.message] }
    end

    def update_status(status)
      previous_status = order.status
      
      if status == :completed && previous_status == "picked_up"
        order.status = "completed_restaurant"
      elsif status == :completed
        order.status = "completed_client"
      else
        order.status = status
      end
    end

    attr_reader :subtotal, :order
  end
end