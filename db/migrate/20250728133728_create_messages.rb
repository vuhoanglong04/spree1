class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages do |t|
      t.references :user, null: false, foreign_key: true
      t.text :content
      t.string :sent_to
      t.timestamp :sent_at

      t.timestamps
    end
  end
end
