class User < ApplicationRecord
    # Relations
    belongs_to :restaurant, optional: true

    # Validations
    validates :email, :password, presence: true
end