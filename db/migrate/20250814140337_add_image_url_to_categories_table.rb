class AddImageUrlToCategoriesTable < ActiveRecord::Migration[8.0]
  def change
    add_column :categories, :image_url, :string
  end
end
