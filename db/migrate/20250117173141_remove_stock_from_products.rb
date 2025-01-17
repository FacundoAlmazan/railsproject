class RemoveStockFromProducts < ActiveRecord::Migration[8.0]
  def change
    remove_column :products, :stock, :integer
  end
end
