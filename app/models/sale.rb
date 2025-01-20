class Sale < ApplicationRecord
  # Scope para ventas activas
  scope :active, -> { where(canceled_at: nil) }

  belongs_to :user
  has_many :sold_products, dependent: :destroy
  has_many :product_variants, through: :sold_products

  validates :sale_date, :total_price, presence: true

    # Método para cancelar ventas
    def cancel!
      transaction do
        sold_products.each do |sold_product|
          # Devolver el stock de cada producto vendido
          sold_product.product.increment!(:stock, sold_product.quantity)
        end
        update(canceled_at: Time.current)
      end
    end
  
    def canceled?
      canceled_at.present?
    end
    
end
