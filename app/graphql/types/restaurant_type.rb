# frozen_string_literal: true

module Types
  class RestaurantType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :address_line_1, String, null: true
    field :address_line_2, String, null: true
    field :postal_code, String, null: true
    field :city, String, null: true
    field :province, String, null: true
    field :country, String, null: true
    field :latitude, Float, null: true
    field :longitude, Float, null: true

    field :users, [Types::UserType], null: false
    field :meals, [Types::MealType], null: false
    field :orders, [Types::OrderType], null: false do
      argument :filters, Types::FilterObjects::OrdersFilterObject, required: false
      complexity 10
    end
    field :has_stripe_account, Boolean, null: false
    field :restaurant_setting, Types::RestaurantSettingType, null: true

    def orders(filters: nil)
      return filters.apply(object) if filters.present?

      object.orders
    end

    def has_stripe_account
      object.stripe_account_id.present?
    end

    def meals
      object.meals.not_archived
    end
  end
end
