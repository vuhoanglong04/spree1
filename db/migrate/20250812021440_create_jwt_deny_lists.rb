class CreateJwtDenyLists < ActiveRecord::Migration[8.0]
  def change
    create_table :jwt_deny_lists do |t|
      t.string :token
      t.timestamp :expired_at
      t.timestamps
    end
    add_index :jwt_deny_lists, :token
    add_reference :jwt_deny_lists, :user, null: false
  end
end
