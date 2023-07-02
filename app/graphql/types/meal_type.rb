# frozen_string_literal: true

module Types
  class MealType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: true
    field :description, String, null: true
    field :active, Boolean, null: true
    field :price, Float, null: true
    field :restaurant, Types::RestaurantType, null: true
  end
end
