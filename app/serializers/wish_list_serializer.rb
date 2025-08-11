class WishListSerializer < ActiveModel::Serializer
  attributes :id
  has_one :product, serializer: ProductsSerializer
end
