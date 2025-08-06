class DropColumnImageUrlInProductVariants < ActiveRecord::Migration[8.0]
  def change
    remove_column :product_variants, :image_url
  end
end
