class UpdateTableProductImages < ActiveRecord::Migration[8.0]
  def change
    drop_table :product_images
    add_column :product_variants, :image_url, :string
    add_column :products, :image_url, :string
  end
end
