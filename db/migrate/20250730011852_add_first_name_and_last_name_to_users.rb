class AddFirstNameAndLastNameToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    remove_column :users, :name
  end
end
