class Api::V1::OrdersController < Api::BaseController
  def index
    page = (params[:page] || "1").to_i
    per_page = 5
    base_key = [
      "orders_page", page,
    ].compact.join("_")

    cache_key = "#{base_key}_cache"

    cache_result = Rails.cache.fetch(cache_key, expires_in: 10.minute) do
      orders = Order.where(user_id: current_user.id).order("id desc").page(params[:page]).per(5)
      {
        data: ActiveModelSerializers::SerializableResource.new(orders, each_serializer: OrderSerializer),
        meta: pagination_meta(orders)
      }
    end
    render_response(data: cache_result[:data],
                    status: 200,
                    message: "Get all orders successfully",
                    meta: cache_result[:meta]
    )
  end

  def show
    order = Order.find_by(id: params[:id])
    raise ActiveRecord::RecordNotFound if order.nil?
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
    order = Order.find_by(id: params[:id])
    raise AuthorizationError, "Your are not allowed to update this order" if current_user.id != order.user_id
    raise AuthorizationError, "Cannot cancel order because it is delivering" if params[:status] == "cancelled" && !%w[processing pending].include?(order.status)
    order.update(status: params[:status])
  end

  private

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
