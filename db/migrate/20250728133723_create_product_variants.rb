class CreateProductVariants < ActiveRecord::Migration[8.0]
  def change
    create_table :product_variants do |t|
      t.references :product, null: true, foreign_key: true
      t.references :size, null: false, foreign_key: true
      t.references :color, null: false, foreign_key: true
      t.decimal :price
      t.integer :stock
      t.string :sku
      t.string :image_url

      t.timestamps
    end
    add_index :product_variants, :sku, unique: true
  end
end
