class Api::V1::HomeController < Api::BaseController
  skip_before_action :authenticate_api
  def index
    five_categories = ActiveModelSerializers::SerializableResource.new(Category.without_deleted.all.limit(5),
                                                                       each_serializer: CategorySerializer)
    five_products = ActiveModelSerializers::SerializableResource.new(Product.without_deleted.all.limit(4),
                                                                     each_serializer: ProductsSerializer
    )
    render_response(data: { categories: five_categories, products: five_products }, status: 200, message: "Home api")
  end
end
