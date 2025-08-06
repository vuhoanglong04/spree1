class RemoveProductIdFromOrderItems < ActiveRecord::Migration[8.0]
  def change
    remove_column :order_items, :product_id
  end
end
