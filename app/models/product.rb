class Product < ApplicationRecord
    scope :active, -> { where(deactivated_at: nil) }

    has_many :sold_products
    has_many :sales, through: :sold_products
    belongs_to :category, optional: true

    has_one_attached :image
    
    validates :name, presence: true, length: { maximum: 255 }
    validates :description, presence: true
    validates :price, presence:true, numericality: { greater_than_or_equal_to: 0 }
    validates :stock, presence:true, numericality: { greater_than_or_equal_to: 0, only_integer: true }

    def deactivate!
        update(deactivated_at: Time.current, stock: 0)
    end

    def active?
        deactivated_at.nil?
    end
      
    def self.ransackable_attributes(auth_object = nil)
        ["category", "color", "created_at", "deactivated_at", "description", "id", "name", "price", "size", "stock", "updated_at"]
    end
    
end
