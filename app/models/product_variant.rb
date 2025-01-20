class ProductVariant < ApplicationRecord
  belongs_to :product
  has_many :sold_products, dependent: :nullify
  has_many :sales, through: :sold_products

  validates :size, presence: true
  validates :color, presence: true
  validates :stock, numericality: { greater_than_or_equal_to: 0 }
end
