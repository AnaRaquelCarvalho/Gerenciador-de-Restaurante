# app/controllers/checkouts_controller.rb
class CheckoutsController < ApplicationController
  # Ignora a verificação de CSRF apenas se o erro persistir,
  # mas o ideal é manter a segurança.

  def create
    # O Rails já parseia o JSON para o hash 'params'
    # Vamos garantir que os itens do carrinho existam
    cart_items = params[:cart]

    if cart_items.blank?
      render json: { error: "Carrinho vazio" }, status: :unprocessable_entity
      return
    end

    begin
      # Configuração do Stripe (Certifique-se de que a Gem está instalada)
      Stripe.api_key = Rails.application.credentials.dig(:stripe, :private_key) || ENV["STRIPE_PRIVATE_KEY"]

      line_items = cart_items.map do |item|
        {
          price_data: {
            currency: "brl",
            product_data: {
              name: item[:name] # O JS já limpou os acentos aqui
            },
            unit_amount: (item[:price].to_f * 100).to_i # Centavos
          },
          quantity: item[:quantity].to_i
        }
      end

      session = Stripe::Checkout::Session.create({
        payment_method_types: [ "card" ], # Adicione 'boost' ou 'pix' se quiser
        line_items: line_items,
        mode: "payment",
        success_url: success_checkouts_url,
        cancel_url: cancel_checkouts_url
      })

      render json: { url: session.url }
    rescue Stripe::StripeError => e
      render json: { error: e.message }, status: :unprocessable_entity
    rescue => e
      # Este log vai te mostrar no terminal exatamente onde dói
      puts "ERRO CRÍTICO NO CHECKOUT: #{e.message}"
      render json: { error: "Erro interno: #{e.message}" }, status: 500
    end
  end
end
