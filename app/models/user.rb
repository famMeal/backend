class User < ApplicationRecord
            # Include default devise modules.
            devise :database_authenticatable, :registerable,
                    :recoverable, :rememberable, :trackable, :validatable,
                    :confirmable, :omniauthable
  include GraphqlDevise::Authenticatable
    # Relations
    belongs_to :restaurant, optional: true
    has_many :orders

    # Validations
    validates :email, presence: true
end