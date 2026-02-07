class CreateStocks < ActiveRecord::Migration[8.1]
  def change
    create_table :stocks do |t|
      t.integer :amount
      t.string :size
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
