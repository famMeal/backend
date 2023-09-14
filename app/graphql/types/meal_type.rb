# frozen_string_literal: true

module Types
  class MealType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :description, String, null: true
    field :active, Boolean, null: false
    field :price, String, null: false
    field :order_start_time, String, null: false
    field :order_cutoff_time, String, null: false
    field :pickup_start_time, String, null: false
    field :pickup_end_time, String, null: false
    field :quantity_available, Integer, null: false
    
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

    def price
      Money.new(object.price * 100, 'CAD').format
    end
  end
end
