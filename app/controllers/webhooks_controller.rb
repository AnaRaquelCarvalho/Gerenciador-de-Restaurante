class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def stripe
    payload = request.body.read
    sig_header = request.env["HTTP_STRIPE_SIGNATURE"]
    endpoint_secret = ENV["STRIPE_WEBHOOK_SECRET"] # <--- Usa a chave do .env

    begin
      event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
    rescue JSON::ParserError, Stripe::SignatureVerificationError => e
      return head :bad_request
    end

    # Quando o pagamento é concluído com sucesso
    if event.type == "checkout.session.completed"
      session = event.data.object
      order = Order.find_by(id: session.metadata.order_id)

      if order
        order.update!(status: :paid, customer_email: session.customer_details.email)
        puts "✅ Pedido ##{order.id} PAGO com sucesso!"

        # Aqui você pode disparar o ActionCable para a cozinha
        # KitchenChannel.broadcast_to("orders", order)
      end
    end

    head :ok
  end
end
