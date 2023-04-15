class Meal < ApplicationRecord
    # Relations
    belongs_to :restaurant
    has_many :orders

    # Validations
    validates :name, :restaurant_id, :active, :price, presence: true
end