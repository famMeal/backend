
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
      @args = args
      @order = Order.find(args[:order_id])
      @quantity = args[:quantity] || order.quantity
      
      raise StandardError.new("Choose either tip percentage or amount, not both") if args[:tip_percentage] && args[:tip_amount]
     
      ActiveRecord::Base.transaction do
        update_status(args[:status]) if args[:status]
        update_pickup_times
        calculate_totals

        order.save!
      end

      { order: order, errors: [] }
    rescue StandardError => e
      { errors: [e.message] }
    end

    def subtotal
      @subtotal ||= Meal.find(order.meal_id).price * quantity
    end

    def calculate_totals
      order.subtotal = subtotal
      order.quantity = quantity
      total_without_tip = subtotal * 1.13
      
      if args[:tip_percentage] && args[:tip_percentage] > 0 || (order.tip_percentage && args[:quantity])
        add_total_with_tip(total_without_tip)
      else
        order.assign_attributes(
          total: total_without_tip,
          tip_amount: 0,
          tip_percentage: 0
        ) 
      end
    end

    def add_total_with_tip(total_without_tip)
      tip_percentage = args[:tip_percentage] || order.tip_percentage
      tip_amount = total_without_tip * (tip_percentage.to_d / 100.00)
      order.assign_attributes(
        total: total_without_tip + tip_amount,
        tip_amount: tip_amount,
        tip_percentage: tip_percentage
      ) 
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

    def update_pickup_times
      order.pickup_start_time = args[:pickup_start_time] if args[:pickup_start_time]
      order.pickup_end_time = args[:pickup_end_time] if args[:pickup_end_time]
    end

    attr_reader :order, :args, :quantity
  end
end