class Category < ApplicationRecord
  # Relationship
  has_many :products
  has_many :children, class_name: 'Category', foreign_key: 'parent_id' #use in serializer
  # Soft Delete
  acts_as_paranoid

  # Validation
  validates :name, presence: true
end
