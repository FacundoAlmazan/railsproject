class AddCustomerIdToSales < ActiveRecord::Migration[8.0]
  def change
    add_column :sales, :customer_id, :string
  end
end
