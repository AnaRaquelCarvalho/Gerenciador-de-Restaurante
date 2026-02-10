class Product < ApplicationRecord
  # Associations
  belongs_to :category
  has_many :stocks, dependent: :destroy
  has_many :order_products

  # ActiveStorage
  has_many_attached :images do |attachable|
    attachable.variant :thumb, resize_to_limit: [ 50, 50 ]
    attachable.variant :medium, resize_to_limit: [ 250, 250 ]
  end

  # Validations
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # Rails 5+ já exige belongs_to por padrão, mas manter não é errado
  validates :category, presence: true

  validate :images_type_and_size

  private

  def images_type_and_size
    return unless images.attached?

    images.each do |image|
      unless image.blob.content_type.in?(%w[image/png image/jpeg image/jpg image/webp])
        errors.add(:images, "devem ser PNG, JPG ou WEBP")
      end

      if image.blob.byte_size > 5.megabytes
        errors.add(:images, "não podem ser maiores que 5MB")
      end
    end
  end
end
