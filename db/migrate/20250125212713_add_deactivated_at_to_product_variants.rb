class AddDeactivatedAtToProductVariants < ActiveRecord::Migration[8.0]
  def change
    add_column :product_variants, :deactivated_at, :datetime
  end
end
