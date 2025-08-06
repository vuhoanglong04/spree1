class UpdateRoleFeature < ActiveRecord::Migration[8.0]
  def change
    drop_table :user_roles if table_exists? :user_roles
    add_reference :users, :role
  end
end
