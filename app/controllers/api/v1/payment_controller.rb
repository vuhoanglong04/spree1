class Api::V1::PaymentController < Api::BaseController
  skip_before_action :authenticate_api

  def create
    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: [
        {
          price_data: {
            currency: 'usd',
            product_data: {
              name: "Cake",
              description: "Delicious chocolate cake",
              images: ["https://media.daily.dev/image/upload/f_auto,q_auto/v1/posts/04db44f0da19625e7a163dfb0bf33ad0?_a=AQAEulh"],
              metadata: { sku: "CAKE123", category: "dessert" }
            },
            unit_amount: 20 * 100
          },
          quantity: 1
        }
      ],
      mode: 'payment',
      success_url: "#{api_v1_payment_path}success?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: "#{root_url}cancel"
    )
    render_response(message: "Create payment link successfully", status: 200, data: session.url)
  rescue Stripe::StripeError => e
    render_response(status: :unprocessable_entity, message: e.message)
  end


  def
end
