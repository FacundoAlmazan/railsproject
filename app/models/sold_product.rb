class SoldProduct < ApplicationRecord
  belongs_to :sale
  belongs_to :product_variant
  
  validates :quantity, :price, presence: true
  validates :product_variant, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # Método para saber si el producto pertenece a una venta cancelada
  def sale_canceled?
    sale.canceled?
  end
  
end
