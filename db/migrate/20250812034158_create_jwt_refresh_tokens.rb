class CreateJwtRefreshTokens < ActiveRecord::Migration[8.0]
  def change
    create_table :jwt_refresh_tokens do |t|
      t.string :jti
      t.timestamp :expired_at
      t.timestamps
    end
    add_index :jwt_refresh_tokens, :jti
    add_reference :jwt_refresh_tokens, :user, null: false
  end
end
