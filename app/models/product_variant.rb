class ProductVariant < ApplicationRecord
  # Relationship
  belongs_to :product
  belongs_to :size
  belongs_to :color

  # Soft Delete
  acts_as_paranoid

  # Validation
  validates :sku, uniqueness: true, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :stock, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :image_url, presence: true
end
