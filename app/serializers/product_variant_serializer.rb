class ProductVariantSerializer < ActiveModel::Serializer
  attributes :id, :price, :stock, :sku, :image_url
  belongs_to :product
end
