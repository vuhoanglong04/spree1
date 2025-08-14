class AddDetailToOrderItemsTable < ActiveRecord::Migration[8.0]
  def change
    add_column :order_items, :detail, :text
  end
end
