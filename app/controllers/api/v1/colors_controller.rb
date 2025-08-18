class Api::V1::ColorsController < Api::BaseController
  skip_before_action :authenticate_api

  def index
    colors = Color.without_deleted.all
    render_response(data: ActiveModelSerializers::SerializableResource.new(colors, each_serializer: ColorSerializer),
                    message: "Get all colors successfully",
                    status: 200
    )
  end
end
