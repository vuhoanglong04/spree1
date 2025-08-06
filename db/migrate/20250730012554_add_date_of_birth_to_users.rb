class AddDateOfBirthToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :date_of_birth, :date
    add_column :users, :phone_number, :string
    add_column :users, :gender, :string
    add_column :users, :bio, :text
  end
end
