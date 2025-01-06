class Sale < ApplicationRecord
  belongs_to :user
  has_many :sold_products, dependent: :destroy
  has_many :products, through: :sold_products

  validates :sale_date, :total_price, presence: true
end
