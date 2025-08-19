class ProductVariantSerializer < ActiveModel::Serializer
  attributes :id, :price, :stock, :sku, :image_url, :size, :color, :stripe_price_id
  belongs_to :product

  def size
    return nil if object.size.nil?
    ActiveModelSerializers::SerializableResource.new(object.size, serializer: SizeSerializer)
  end

  def color
    return nil if object.color.nil?
    ActiveModelSerializers::SerializableResource.new(object.color, serializer: ColorSerializer)
  end
end
