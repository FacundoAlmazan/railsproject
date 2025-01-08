class SoldProduct < ApplicationRecord
  belongs_to :sale
  belongs_to :product
  
  validates :quantity, :price, presence: true

  # Método para saber si el producto pertenece a una venta cancelada
  def sale_canceled?
    sale.canceled?
  end
  
end
