class RestaurantSetting < ApplicationRecord
    # Relations
    belongs_to :restaurant

    # Validations
    validates :restaurant_id, :order_start_time, :order_cutoff_time, :pickup_start_time, :pickup_end_time, :byob_tupperware, presence: true
end