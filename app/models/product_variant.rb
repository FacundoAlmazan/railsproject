class ProductVariant < ApplicationRecord
  scope :active, -> { where(deactivated_at: nil) }

  belongs_to :product
  has_many :sold_products, dependent: :nullify
  has_many :sales, through: :sold_products

  validates :size, presence: true
  validates :color, presence: true
  validates :stock, numericality: { greater_than_or_equal_to: 0 }

  # Método para mostrar detalles del producto variante
  def details
    "#{product.name} - Talle: #{size}, Color: #{color}, Stock: #{stock} Precio de lista: $#{product.price}"
  end

  # Lo mismo pero sin el stock
  def details2
    "#{product.name} - Talle: #{size}, Color: #{color}, Precio de lista: $#{product.price}"
  end

  def deactivate!
    update!(deactivated_at: Time.current)
  end
  
  def active?
    deactivated_at.nil?
  end

end
