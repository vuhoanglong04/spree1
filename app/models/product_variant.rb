class ProductVariant < ApplicationRecord
  attr_accessor :default_variant_flag

  # Relationship
  belongs_to :product
  belongs_to :size, optional: true
  belongs_to :color, optional: true

  # Soft Delete
  acts_as_paranoid

  # Validation
  validates :sku, uniqueness: true, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :stock, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :image_url, presence: true
  validates :color_id, presence: true, unless: ->(record) { record.default_variant_flag }
  validates :size_id, presence: true, unless: ->(record) { record.default_variant_flag }

  private

end
