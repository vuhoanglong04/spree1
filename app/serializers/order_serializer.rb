class OrderSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :street, :city, :state, :zip, :country, :phone_number, :stripe_payment_id, :status, :total_amount, :created_at
  has_many :order_items, serializer: OrderItemSerializer
  def created_at
    object.created_at.to_datetime.strftime("%d/%m/%Y %H:%M")
  end
end
