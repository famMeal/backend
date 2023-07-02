# frozen_string_literal: true

module Types
  class OrderType < Types::BaseObject
    field :id, ID, null: false
    field :status, String, null: true
    field :quantity, Integer, null: true
    field :pickup_start_time, String, null: true
    field :pickup_end_time, String, null: true
    field :tip_amount, Float, null: true
    field :total, Float, null: true
    field :subtotal, Float, null: true

    field :meal, Types::MealType, null: true
    field :restaurant, Types::RestaurantType, null: true
    field :user, Types::UserType, null: true
  end
end
