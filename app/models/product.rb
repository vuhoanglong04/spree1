class Product < ApplicationRecord
  after_commit :clear_cache

  # Relationship
  has_many :product_variants
  belongs_to :category

  # Soft Delete
  acts_as_paranoid

  # Validation
  validates :name, presence: true
  validates :description, uniqueness: true
  validates :brand, presence: true
  validates :category_id, presence: true
  validates :image_url, presence: true

  private

  def clear_cache
    Rails.cache.delete_matched("products_")
  end
end
