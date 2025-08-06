class DropTableAddresses < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :street, :string
    add_column :orders, :city, :string
    add_column :orders, :state, :string
    add_column :orders, :zip, :string
    add_column :orders, :country, :string
    add_column :orders, :phone_number, :string
    change_column_null :orders, :user_id, true

  end
end
