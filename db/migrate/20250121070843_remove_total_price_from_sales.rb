class RemoveTotalPriceFromSales < ActiveRecord::Migration[8.0]
  def change
    remove_column :sales, :total_price, :decimal
  end
end