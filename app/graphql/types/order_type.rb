# frozen_string_literal: true

module Types
  class OrderType < Types::BaseObject
    field :id, ID, null: false
    field :status, String, null: true
    field :quantity, Integer, null: true
    field :pickup_start_time, String, null: true
    field :pickup_end_time, String, null: true
    field :tip_amount, String, null: true
    field :total, String, null: true
    field :subtotal, String, null: true

    field :meal, Types::MealType, null: true
    field :restaurant, Types::RestaurantType, null: true
    field :user, Types::UserType, null: true

    def tip_amount
      Money.new(object.tip_amount * 100, 'CAD').format
    end
  
    def total
      Money.new(object.total * 100, 'CAD').format
    end
  
    def subtotal
      Money.new(object.subtotal * 100, 'CAD').format
    end
  end
end
