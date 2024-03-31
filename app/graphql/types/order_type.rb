# frozen_string_literal: true

module Types
  class OrderType < Types::BaseObject
    field :id, ID, null: false
    field :status, String, null: true
    field :quantity, Integer, null: true
    field :pickup_start_time, String, null: true
    field :pickup_end_time, String, null: true
    field :order_placed_at, String, null: true
    field :tip_amount, String, null: true
    field :tip_percentage, Integer, null: true
    field :total, String, null: true
    field :taxes, String, null: true
    field :subtotal, String, null: true
    field :created_at, String, null: true

    field :meal, Types::MealType, null: true
    field :restaurant, Types::RestaurantType, null: true
    field :user, Types::UserType, null: true

    def tip_amount
      Money.new(object.tip_amount * 100, 'CAD').format
    end
  
    def total
      Money.new(object.total * 100, 'CAD').format
    end

    def taxes
      Money.new(object.subtotal * 13, 'CAD').format
    end
  
    def subtotal
      Money.new(object.subtotal * 100, 'CAD').format
    end
    
    def status
      if object.status == "completed_client" || object.status == "completed_restaurant"
        "completed"
      else
        object.status
      end
    end
  end
end
