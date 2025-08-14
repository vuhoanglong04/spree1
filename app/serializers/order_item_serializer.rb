class OrderItemSerializer < ActiveModel::Serializer
  attributes :quantity, :price, :detail
end
