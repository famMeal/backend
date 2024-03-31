# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :first_name, String, null: true
    field :last_name, String, null: true
    field :email, String, null: false
    field :is_store_owner, Boolean, null: true
    
    field :restaurant, Types::RestaurantType, null: true
    field :orders, [Types::OrderType], null: false do
      argument :filters, Types::FilterObjects::OrdersFilterObject, required: false
      complexity 10
    end

    def orders(filters: nil)
      return filters.apply(object) if filters.present?

      object.orders
    end
  end
end
