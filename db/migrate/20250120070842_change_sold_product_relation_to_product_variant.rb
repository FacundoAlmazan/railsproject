class ChangeSoldProductRelationToProductVariant < ActiveRecord::Migration[8.0]
  def change
    remove_reference :sold_products, :product, foreign_key: true
    add_reference :sold_products, :product_variant, null: false, foreign_key: true
  end
end
