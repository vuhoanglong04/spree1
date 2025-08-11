class WishList < ApplicationRecord
  # Relationship
  belongs_to :user
  belongs_to :product
  # Validation
  validates :user_id, presence: true
  validates :product_id, presence: true
end
