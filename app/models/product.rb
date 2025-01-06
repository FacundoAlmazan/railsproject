class Product < ApplicationRecord
    has_many :sold_products
    has_many :sales, through: :sold_products
  
    validates :name, :price, :stock, presence: true
end
