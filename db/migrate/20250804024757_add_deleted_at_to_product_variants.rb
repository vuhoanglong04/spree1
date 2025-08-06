class AddDeletedAtToProductVariants < ActiveRecord::Migration[8.0]
  def change
    add_column :product_variants, :deleted_at, :timestamp
  end
end
