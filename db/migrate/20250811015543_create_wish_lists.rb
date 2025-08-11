class CreateWishLists < ActiveRecord::Migration[8.0]
  def change
    create_table :wish_lists do |t|
      t.references :user, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
