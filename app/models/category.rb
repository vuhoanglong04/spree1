class Category < ApplicationRecord
  # Relationship
  has_many :products

  # Soft Delete
  acts_as_paranoid

  # Validation
  validates :name, presence: true
end
