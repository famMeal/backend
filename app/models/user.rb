class User < ApplicationRecord
    # Relations
    belongs_to :restaurant

    # Validations
    validates :email, :password, presence: true
end