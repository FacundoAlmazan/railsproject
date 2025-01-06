class CreateSales < ActiveRecord::Migration[8.0]
  def change
    create_table :sales do |t|
      t.datetime :sale_date
      t.decimal :total_price
      t.references :user, null: false, foreign_key: true
      t.string :client_name

      t.timestamps
    end
  end
end
