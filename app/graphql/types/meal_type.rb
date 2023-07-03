# frozen_string_literal: true

module Types
  class MealType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: true
    field :description, String, null: true
    field :active, Boolean, null: true
    field :price, Float, null: true
    field :order_start_time, String, null: true
    field :order_cutoff_time, String, null: true
    field :pickup_start_time, String, null: true
    field :pickup_end_time, String, null: true
    field :quantity_available, Integer, null: true
    
    field :restaurant, Types::RestaurantType, null: true

    def order_start_time
      object.restaurant_setting.order_start_time
    end

    def order_cutoff_time
      object.restaurant_setting.order_cutoff_time
    end

    def pickup_start_time
      object.restaurant_setting.pickup_start_time
    end

    def pickup_end_time
      object.restaurant_setting.pickup_end_time
    end

    def quantity_available
      object.restaurant_setting.quantity_available
    end
  end
end
