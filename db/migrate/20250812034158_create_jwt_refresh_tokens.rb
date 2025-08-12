class CreateJwtRefreshTokens < ActiveRecord::Migration[8.0]
  def change
    create_table :jwt_refresh_tokens do |t|
      t.string :token
      t.timestamp :expired_at
      t.timestamps
    end
    add_index :jwt_refresh_tokens, :token
    add_reference :jwt_refresh_tokens, :user, null: false
  end
end
