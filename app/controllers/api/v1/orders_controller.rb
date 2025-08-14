class Api::V1::OrdersController < Api::BaseController
  def index
    orders = Order.where(user_id: params[:user_id]).page(params[:page]).per(5)
    render_response(data: ActiveModelSerializers::SerializableResource.new(orders, each_serializer: OrderSerializer),
                    status: 200,
                    message: "Get all orders successfully",
                    meta: orders
    )
  end

  def show
    order = Order.find(params[:id])
    render_response(data: ActiveModelSerializers::SerializableResource.new(order, serializer: OrderSerializer),
                    status: 200,
                    message: "Get order successfully"
    )
  end

  def create
    ActiveRecord::Base.transaction do
      order = Order.create!(order_params)
      update_product_variant_stock(order)
      render_response(data: ActiveModelSerializers::SerializableResource.new(order, serializer: OrderSerializer),
                      status: :created,
                      message: "Order created")
    end
  end

  def update

  end

  def order_params
    params.require(:order).permit(
      :user_id,
      :status,
      :total_amount,
      :stripe_payment_id,
      :street,
      :city,
      :state,
      :zip,
      :country,
      :phone_number,
      order_items_attributes: [
        :product_variant_id,
        :quantity,
        :price,
        :detail
      ]
    )
  end

  private

  def update_product_variant_stock(order)
    order.order_items.each do |item|
      variant = ProductVariant.find(item.product_variant_id)
      new_stock = variant.stock - item.quantity

      if new_stock < 0
        raise ActiveRecord::RecordInvalid.new(variant), "Not enough stock for #{variant.name}"
      end

      variant.update!(stock: new_stock)
    end
  end
end
