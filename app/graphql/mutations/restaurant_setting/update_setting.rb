
module Mutations::RestaurantSetting
  class UpdateSetting < Mutations::BaseMutation
    argument :pickup_start_time, String, required: false
    argument :pickup_end_time, String, required: false
    argument :order_start_time, String, required: false
    argument :order_cutoff_time, String, required: false
    argument :quantity_available, Integer, required: false
    argument :restaurant_id, ID, required: true

    field :errors, [String], null: false
    field :restaurant_setting, Types::RestaurantSettingType, null: true

    def resolve(**args)
      setting = RestaurantSetting.find_by(restaurant_id: args[:restaurant_id])
      attributes = args.slice(:pickup_start_time, :pickup_end_time, :order_start_time, :order_cutoff_time, :quantity_available)
      setting.update!(attributes)

      { restaurant_setting: setting, errors: [] }
    rescue StandardError => e
      { errors: [e.message] }
    end
  end
end