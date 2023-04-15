class Order < ApplicationRecord
    # Relations
    belongs_to :meal
    belongs_to :restaurant, through: :meal

    # Validations
    validates :meal_id, :quantity, :tip_amount, :total, :subtotal, :status, :pickup_start_time, :pickup_end_time, :byob_tupperware, presence: true
end