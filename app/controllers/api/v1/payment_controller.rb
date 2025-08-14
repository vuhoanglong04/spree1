class Api::V1::PaymentController < Api::BaseController
  skip_before_action :authenticate_api

  def create
    items = []
    order_params[:order_items_attributes].each do |item_params|
      detail_json = JSON.parse(item_params[:detail])
      name = detail_json[:color].nil? ? detail_json["product_name"] : "#{detail_json["product_name"]}" + "/#{detail_json["color"]}/#{detail_json["size"]}"
      items << {
        price_data: {
          currency: 'usd',
          product_data: {
            name: name,
            images: [detail_json["image_url"]],
          },
          unit_amount: (item_params[:price].to_f * 100).to_i
        },
        quantity: item_params[:quantity].to_i
      }
    end

    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: items,
      mode: 'payment',
      success_url: "#{root_url}success",
      cancel_url: "#{root_url}cancel",
      payment_intent_data: {
        metadata: { order_id: order_params[:order_id] },
      },
    )
    render_response(message: "Create payment link successfully", status: 200, data: session.url)
  rescue Stripe::StripeError => e
    render_response(status: :unprocessable_entity, message: e.message)
  end

  def order_params
    params.permit(
      :order_id,
      order_items_attributes: [
        :product_variant_id,
        :quantity,
        :price,
        :detail
      ]
    )
  end
end
