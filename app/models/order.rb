class Order < ApplicationRecord
    # Relations
    belongs_to :meal
    belongs_to :user

    # Validations
    validates :user_id, :meal_id, :quantity, :tip_amount, :total, :subtotal, :status, :pickup_start_time, :pickup_end_time, presence: true
end