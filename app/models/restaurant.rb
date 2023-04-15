class Restaurant < ApplicationRecord
    # Relations
    has_many :meals
    has_many :restaurant_settings
    has_many :users

    # Validations
    validates :name, presence: true
    validates :country, inclusion: { in: ["canada"] }, allow_nil: true
end