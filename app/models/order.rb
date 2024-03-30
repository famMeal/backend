class Order < ApplicationRecord
  # Relations
  belongs_to :meal
  has_one :restaurant, :through => :meal
  belongs_to :user

  # Validations
  validates :status, inclusion: { in: %w(cart payment_failed preparing ready picked_up completed-client completed-restaurant cancelled) }
  validates :user_id, :meal_id, :quantity, :tip_amount, :total, :subtotal, :status, :pickup_start_time, :pickup_end_time, presence: true
  
  scope :by_restaurant_and_status, ->(restaurant_id, status) {
    joins(:meal).where(meals: { restaurant_id: restaurant_id }, status: status)
  }
end