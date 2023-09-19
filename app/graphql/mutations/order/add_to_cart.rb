
module Mutations::Order
  class AddToCart < Mutations::BaseMutation
    argument :pickup_start_time, String, required: true
    argument :pickup_end_time, String, required: true
    argument :quantity, Integer, required: false
    argument :meal_id, ID, required: true
    argument :user_id, ID, required: true

    field :errors, [String], null: false
    field :order, Types::OrderType, null: true

    def resolve(**args)
      order = Order.create!(
        pickup_start_time: args[:pickup_start_time],
        pickup_end_time: args[:pickup_end_time],
        quantity: args[:quantity],
        meal_id: args[:meal_id],
        user_id: args[:user_id],
        tip_amount: 0,
        subtotal: calculate_subtotal(args[:quantity], args[:meal_id]),
        total: subtotal * 1.13
      )

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