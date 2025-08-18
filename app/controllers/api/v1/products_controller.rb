class Api::V1::ProductsController < Api::BaseController
  skip_before_action :authenticate_api, only: [:index, :show]

  def index
    products = Product.without_deleted
    products = products.where(category_id: params[:category_id]) if params[:category_id]
    products = products.all.page(params[:page]).per(5)

    render_response(data: ActiveModelSerializers::SerializableResource.new(products, each_serializer: ProductsSerializer),
                    message: "Get all products successfully",
                    status: 200,
                    meta: products
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
