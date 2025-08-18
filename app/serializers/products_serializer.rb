class ProductsSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :brand, :category_id, :image_url
  has_many :product_variants , serializer: ProductVariantSerializer
end
