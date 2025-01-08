class AddCanceledAtToSales < ActiveRecord::Migration[8.0]
  def change
    add_column :sales, :canceled_at, :datetime
  end
end
