class RemoveNotNullProductIdInProductVariantsTable < ActiveRecord::Migration[8.0]
  def change
    change_column_null :product_variants, :product_id, true
  end
end