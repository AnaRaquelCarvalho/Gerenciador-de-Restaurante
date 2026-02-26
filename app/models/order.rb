class Order < ApplicationRecord
  has_many :order_products, dependent: :destroy
  has_many :products, through: :order_products

  # Define os status (o Rails gerencia os números 0, 1, 2 automaticamente)
  enum :status, { pending: 0, paid: 1, failed: 2, preparing: 3, delivered: 4 }

  # Método para converter o total para centavos (exigência do Stripe)
  def total_in_cents
    (total.to_f * 100).to_i
  end
end
