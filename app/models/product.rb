class Product < ApplicationRecord
  # Associations
  belongs_to :category

  # ActiveStorage
  has_many_attached :images do |attachable|
    attachable.variant :thumb, resize_to_limit: [ 50, 50 ]
  end

  # Validations
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :category, presence: true

  # Optional: validação de imagens
  validate :images_type_and_size

  private

  def images_type_and_size
    return unless images.attached?

    images.each do |image|
      unless image.content_type.in?(%w[image/png image/jpeg image/jpg image/webp])
        errors.add(:images, "devem ser PNG, JPG ou WEBP")
      end

      if image.byte_size > 5.megabytes
        errors.add(:images, "não podem ser maiores que 5MB")
      end
    end
  end
end
