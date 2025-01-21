class Sale < ApplicationRecord
  # Scope para ventas activas
  scope :active, -> { where(canceled_at: nil) }

  belongs_to :user
  
  has_many :sold_products, dependent: :destroy
  accepts_nested_attributes_for :sold_products, allow_destroy: true

  has_many :product_variants, through: :sold_products

  validates :customer_id, presence: true, length: { maximum: 20 }, numericality: { only_integer: true }

  # Sobrescribe create para validar el stock

  def save_with_stock_validation
    transaction do
      puts "Comenzando validación de stock para la venta: #{self.inspect}"
      sold_products.each do |sold_product|
        variant = sold_product.product_variant
        puts "Validando stock para variante: #{variant.inspect}"
        if variant.stock < sold_product.quantity
          puts "Stock insuficiente: #{variant.stock} < #{sold_product.quantity}"
          errors.add(:base, "Stock insuficiente para el producto: #{variant.product.name} (Talle: #{variant.size}, Color: #{variant.color})")
          raise ActiveRecord::Rollback
        else
          puts "Descontando stock: #{variant.stock} - #{sold_product.quantity}"
          variant.decrement!(:stock, sold_product.quantity)
        end
      end
      save!
      puts "Venta guardada exitosamente."
    end
  rescue => e
    puts "Error en la transacción: #{e.message}"
    false
  end

  # Método dinámico para calcular el total de la venta
  def total_price
    sold_products.sum { |sp| sp.price * sp.quantity }
  end
  

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

  # Calcula el precio total sumando los precios de los productos vendidos
  def calculate_total_price
    self.total_price = sold_products.sum { |sp| sp.price * sp.quantity }
  end
    
end
