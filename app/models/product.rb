class Product < ApplicationRecord
    scope :active, -> { where(deactivated_at: nil) }

    has_many :product_variants, dependent: :destroy
    accepts_nested_attributes_for :product_variants, allow_destroy: true

    belongs_to :category

    has_one_attached :image

    # Atributo virtual para el checkbox
    attr_accessor :remove_image

    # Callback para eliminar la imagen si el checkbox está marcado
    before_save :purge_image_if_requested

    def stock
        product_variants.active.sum(:stock)
    end

  def deactivate!
    transaction do
      product_variants.update_all(deactivated_at: Time.current) # Desactiva todas las variantes
      update!(deactivated_at: Time.current)
    end
  end

    private

    def purge_image_if_requested
        puts "Remove Image: #{remove_image}" # Verifica el valor
        image.purge if ActiveModel::Type::Boolean.new.cast(remove_image)
    end
    
    validates :name, presence: true, length: { maximum: 10 }
    validates :description, presence: true
    validates :price, presence:true, numericality: { greater_than_or_equal_to: 0 }

    def active?
        deactivated_at.nil?
    end
      
    def self.ransackable_attributes(auth_object = nil)
        ["category", "color", "created_at", "deactivated_at", "description", "id", "name", "price", "size", "stock", "updated_at"]
    end
    
end
