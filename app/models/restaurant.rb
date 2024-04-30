class Restaurant < ApplicationRecord
  # Relations
  has_many :meals
  has_many :orders, :through => :meals
  has_one :restaurant_setting
  has_many :users

  # Validations
  validates :name, presence: true
  validates :country, inclusion: { in: ["canada"] }, allow_nil: true
  
  def store_owner 
    users.find_by(is_store_owner: true)
  end
end
