class Api::V1::CategoriesController < Api::BaseController
  skip_before_action :authenticate_api, only: [:index, :show]

  def index
    categories = Category.without_deleted.all.page(params[:page]).per(5)
    render_response(data: ActiveModelSerializers::SerializableResource.new(categories, each_serializer: CategorySerializer),
                    message: "Get all categories successfully",
                    status: 200,
                    meta: categories
    )
  end

  # GET /categories/1 or /categories/1.json
  def show
    category = Category.without_deleted.find_by(id: params[:id])
    raise ActiveRecord::RecordNotFound, "Category not found" if category.nil?
    render_response(data: ActiveModelSerializers::SerializableResource.new(category, serializer: CategorySerializer),
                    message: "Get category successfully",
                    status: 200
    )
  end

end
