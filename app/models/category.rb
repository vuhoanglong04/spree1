class Category < ApplicationRecord
  after_commit :clear_cache
  # Relationship
  has_many :products
  has_many :children, class_name: 'Category', foreign_key: 'parent_id' # use in serializer
  # Soft Delete
  acts_as_paranoid

  # Validation
  validates :name, presence: true
  validates :image_url, presence: true, on: :create

  def clear_cache
    Rails.cache.delete_matched("categories_")
  end
end
