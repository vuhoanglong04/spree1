class Product < ApplicationRecord
  # Elasticsearch
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  def as_indexed_json(options = {})
    as_json(
      only: [:id, :name, :description, :brand, :category_id, :image_url, :stripe_price_id],
      include: {
        product_variants: {
          only: [:id, :sku, :price, :stock, :image_url, :stripe_product_id, :stripe_price_id],
          include: {
            size: { only: [:id, :name] },
            color: { only: [:id, :name, :hex_code] }
          }
        }
      }
    )
  end

  settings do
    mappings dynamic: false do
      indexes :id, type: :integer
      indexes :name, type: :text, analyzer: :standard
      indexes :description, type: :text, analyzer: :standard
      indexes :brand, type: :keyword
      indexes :category_id, type: :integer
      indexes :image_url, type: :keyword
      indexes :stripe_price_id, type: :keyword
      indexes :product_variants, type: :nested do
        indexes :id, type: :integer
        indexes :sku, type: :keyword
        indexes :price, type: :float
        indexes :stock, type: :integer
        indexes :image_url, type: :keyword
        indexes :stripe_product_id, type: :keyword
        indexes :stripe_price_id, type: :keyword

        indexes :size, type: :nested do
          indexes :id, type: :integer
          indexes :name, type: :text, analyzer: :standard
        end

        indexes :color, type: :nested do
          indexes :id, type: :integer
          indexes :name, type: :text, analyzer: :standard
          indexes :hex_code, type: :keyword
        end
      end
    end
  end

  # Callback
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
