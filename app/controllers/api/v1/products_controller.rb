class Api::V1::ProductsController < Api::BaseController
  skip_before_action :authenticate_api, only: [:index, :show]

  def index
    page = (params[:page] || 1).to_i
    per_page = 5

    # Optional filters
    category_id = params[:category_id]
    search_name = params[:name]
    min_price = params[:min_price]
    max_price = params[:max_price]

    # Build unique cache key based on page and filters
    base_key = [
      "products_page", page,
      ("category_#{category_id}" if category_id),
      ("name_#{search_name}" if search_name),
      ("min_#{min_price}" if min_price),
      ("max_#{max_price}" if max_price)
    ].compact.join("_")

    cache_key = "#{base_key}_cache"

    # Cache both data and meta in a single fetch
    cached_result = Rails.cache.fetch(cache_key) do
      products = Product.without_deleted
      products = products.where(category_id: category_id) if category_id
      products = products.where("name ILIKE ?", "%#{search_name}%") if search_name
      products = products.where("price >= ?", min_price.to_f) if min_price
      products = products.where("price <= ?", max_price.to_f) if max_price

      paginated = products.page(page).per(per_page)

      {
        data: ActiveModelSerializers::SerializableResource.new(paginated, each_serializer: ProductsSerializer).as_json,
        meta: pagination_meta(paginated)
      }
    end

    render_response(
      data: cached_result[:data],
      message: "Get all products successfully",
      status: 200,
      meta: cached_result[:meta]
    )
  end

  # GET /products/1 or /products/1.json
  def show
    product = Product.without_deleted.find_by(id: params[:id])
    raise ActiveRecord::RecordNotFound, "Product not found" if product.nil?
    render_response(data: ActiveModelSerializers::SerializableResource.new(product, serializer: ProductsSerializer),
                    message: "Get product successfully",
                    status: 200
    )
  end
end
