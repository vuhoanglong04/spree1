class ChangeColorAndSizeNullInProductVariantsTable < ActiveRecord::Migration[8.0]
  def change
    change_column_null :product_variants, :color_id, true
    change_column_null :product_variants, :size_id, true
  end
end
