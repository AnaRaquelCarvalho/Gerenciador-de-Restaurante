class OrderProduct < ApplicationRecord
  belongs_to :order
  belongs_to :product

  # Garante que a quantidade mínima seja 1
  validates :quantity, presence: true, numericality: { greater_than: 0 }
end