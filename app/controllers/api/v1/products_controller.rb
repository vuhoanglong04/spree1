class Api::V1::ProductsController < Api::BaseController
  def index
    products = Product.without_deleted.all.page(params[:page]).per(5)

    render_response(data: ActiveModelSerializers::SerializableResource.new(products, each_serializer: ProductsSerializer),
                    message: "Get all products successfully",
                    status: 200,
                    meta: products
    )
  end

  def show
    render json: @product
  end

  def create
    product = Product.new(product_params)
    if product.save
      render json: product, status: :created
    else
      render json: product.errors, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      render json: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    head :no_content
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :price, :description)
  end
end
