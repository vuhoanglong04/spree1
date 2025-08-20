class Api::V1::PaymentController < Api::BaseController

  def create
    items = []
    order_params[:items].each do |item_params|
      items << {
        price: item_params[:stripe_price_id],
        quantity: item_params[:quantity],
      }
    end

    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: items,
      mode: 'payment',
      success_url: "http://localhost:5173/payment/success",
      cancel_url: "http://localhost:5173/payment/error",
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
      items: [
        :stripe_price_id,
        :quantity,
      ]
    )
  end
end
