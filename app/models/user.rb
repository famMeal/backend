class User < ApplicationRecord
    # Relations
    belongs_to :restaurant, optional: true
    has_many :orders

    # Validations
    validates :email, :password, presence: true
end