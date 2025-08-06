class CreatePermissions < ActiveRecord::Migration[8.0]
  def change
    create_table :permissions do |t|
      t.string :action
      t.string :subject

      t.timestamps
    end
  end
end
