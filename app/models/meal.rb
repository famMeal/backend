class Meal < ApplicationRecord
    # Relations
    belongs_to :restaurant
    has_many :orders
    has_one :restaurant_setting, :through => :restaurant

    # Validations
    validates :name, :restaurant_id, :price, presence: true

    scope :not_archived, -> { where(archived: false) }
end