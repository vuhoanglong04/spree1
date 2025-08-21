class UpdateProductVariantToStripeJob < ApplicationJob
  queue_as :default

  def perform(*args)
    ProductVariant.find_each do |variant|
      product = variant.product
      name = product.name
      name = "#{product.name}/#{variant.color.name}/#{variant.size.name}" if variant.color && variant.size
      if variant.stripe_product_id && variant.stripe_price_id
        Stripe::Product.update(
          variant.stripe_product_id,
          {
            name: name,
            description: product.description,
            images: [variant.image_url || Faker::Avatar.image]
          }
        )
      else
        ProductsService.sync_with_stripe(variant, name, product.description)
      end
    end
  end
end
