class CreateCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :categories do |t|
      t.string :name
      t.timestamp :deleted_at
      t.timestamps
    end
    add_reference :categories, :parent, foreign_key: { to_table: :categories }
  end
end
