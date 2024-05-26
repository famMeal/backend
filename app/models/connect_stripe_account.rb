class ConnectStripeAccount < ApplicationRecord
  # Relations
  belongs_to :restaurant
  belongs_to :user
end
