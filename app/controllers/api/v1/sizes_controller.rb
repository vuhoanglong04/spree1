class Api::V1::SizesController < Api::BaseController
  skip_before_action :authenticate_api, only: [:index]

  def index
    sizes = Size.without_deleted.all
    render_response(data: ActiveModelSerializers::SerializableResource.new(sizes, each_serializer: SizeSerializer),
                    message: "Get all sizes successfully",
                    status: 200
    )
  end
end
