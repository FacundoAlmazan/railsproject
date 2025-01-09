class Product < ApplicationRecord
    scope :active, -> { where(deactivated_at: nil) }

    has_many :sold_products
    has_many :sales, through: :sold_products
    belongs_to :category, optional: true

    has_one_attached :image

    # Atributo virtual para el checkbox
    attr_accessor :remove_image

    # Callback para eliminar la imagen si el checkbox está marcado
    before_save :purge_image_if_requested

    private

    def purge_image_if_requested
        puts "Remove Image: #{remove_image}" # Verifica el valor
        image.purge if ActiveModel::Type::Boolean.new.cast(remove_image)
    end
    
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
