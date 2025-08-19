class ProductsService
  def self.create_variant(product, stock:, sku:, price:)
    default_variant = ProductVariant.new(product_id: product.id, stock: stock, price: price, sku: sku, image_url: product.image_url)
    default_variant.default_variant_flag = true
    default_variant.save!
    self.sync_with_stripe(default_variant, product.name, product.description)
  end

  def self.sync_with_stripe(variant, name, description)
    name = "#{name}/#{variant.color.name}/#{variant.size.name}" if variant.color && variant.size
    stripe_product = Stripe::Product.create(
      name: name,
      description: description,
      images: [variant.image_url || Faker::Avatar.image],
    )

    stripe_price = Stripe::Price.create(
      unit_amount: (variant.price * 100).to_i,
      currency: "usd",
      product: stripe_product.id
    )

    variant.update!(
      stripe_product_id: stripe_product.id,
      stripe_price_id: stripe_price.id
    )
  end
end