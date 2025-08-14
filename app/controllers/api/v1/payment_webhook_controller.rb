class Api::V1::PaymentWebhookController < Api::BaseController
  skip_before_action :authenticate_api

  def receive
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = ENV['STRIPE_WEBHOOK_SECRET']

    begin
      event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
    rescue JSON::ParserError
      return head :bad_request
    rescue Stripe::SignatureVerificationError
      return head :unauthorized
    end

    case event.type
    when 'charge.succeeded'
      session = event.data.object
      handle_checkout_session(session)
    else
      Rails.logger.info("Unhandled event type: #{event.type}")
    end

    head :ok
  end

  private

  def handle_checkout_session(session)
    order_id = session.metadata.order_id
    order = Order.find(order_id)

    if order && order.status == "pending"
      order.update(status: 'paid' , stripe_payment_id: session.payment_intent)
      Rails.logger.info("✅ Order #{order.id} marked as paid")
    else
      Rails.logger.warn("⚠️ Order not found or payment not completed for session #{session.id}")
    end
  end
end
