class CreateJwtRefreshTokens < ActiveRecord::Migration[8.0]
  def change
    create_table :jwt_refresh_tokens do |t|
      t.string :token, null: false
      t.timestamp :expired_at, null: false
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end

    add_index :jwt_refresh_tokens, :token, unique: true
    add_index :jwt_refresh_tokens, :expired_at
  end
end
