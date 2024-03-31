class Order < ApplicationRecord
  include AASM

  # Relations
  belongs_to :meal
  has_one :restaurant, :through => :meal
  belongs_to :user

  # Validations
  validates :status, inclusion: { in: %w(cart payment_failed preparing ready picked_up completed_client completed_restaurant cancelled) }
  validates :user_id, :meal_id, :quantity, :tip_amount, :total, :subtotal, :status, :pickup_start_time, :pickup_end_time, presence: true
  
  scope :by_restaurant_and_status, ->(restaurant_id, status) {
    joins(:meal).where(meals: { restaurant_id: restaurant_id }, status: status)
  }

  aasm column: 'status' do
    state :cart, initial: true
    state :payment_failed
    state :preparing
    state :ready
    state :picked_up
    state :completed_client
    state :completed_restaurant
    state :cancelled

    event :place_order do
      transitions from: :cart, to: :preparing, after: :set_order_placed_at
    end
  end

  private

    def set_order_placed_at
      self.order_placed_at = DateTime.now
    end
end