class Api::V1::CategoriesController < Api::BaseController
  skip_before_action :authenticate_api, only: [:index, :show]

  def index
    page = (params[:page] || 1).to_i
    per_page = 5

    base_key = [
      "categories_page", page,
    ].compact.join("_")

    cache_key = "#{base_key}_cache"

    cached_result = Rails.cache.fetch(cache_key) do
      categories = Category.without_deleted.all.page(page).per(per_page)
      {
        data: ActiveModelSerializers::SerializableResource.new(categories, each_serializer: CategorySerializer).as_json,
        meta: pagination_meta(categories)
      }
    end

    render_response(data: cached_result[:data],
                    message: "Get all categories successfully",
                    status: 200,
                    meta: cached_result[:meta]
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
