class AddStripeDetailToProductVariants < ActiveRecord::Migration[8.0]
  def change
    add_column :product_variants, :stripe_product_id, :string
    add_column :product_variants, :stripe_price_id, :string
  end
end
