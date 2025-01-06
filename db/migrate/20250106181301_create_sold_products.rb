class CreateSoldProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :sold_products do |t|
      t.references :sale, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity
      t.decimal :price

      t.timestamps
    end
  end
end
