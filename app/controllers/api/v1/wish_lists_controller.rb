class Api::V1::WishListsController < Api::BaseController
  def index
    wishlists = WishList.where(user_id: params[:user_id]).page(params[:page]).per(5)

    render_response(data: ActiveModelSerializers::SerializableResource.new(wishlists, each_serializer: WishListSerializer),
                    message: "Get all wishlist successfully",
                    status: 200,
                    meta: wishlists
    )
  end
end
