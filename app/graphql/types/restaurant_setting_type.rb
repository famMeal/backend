# frozen_string_literal: true

module Types
  class RestaurantSettingType < Types::BaseObject
    field :id, ID, null: false
    field :order_start_time, String, null: true
    field :order_cutoff_time, String, null: true
    field :pickup_start_time, String, null: true
    field :pickup_end_time, String, null: true
    field :quantity_available, Integer, null: true
    field :byob_tupperware, Boolean, null: true
  end
end
