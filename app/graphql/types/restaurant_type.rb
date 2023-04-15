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
  end
end
