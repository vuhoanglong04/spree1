class Api::V1::UsersController < Api::BaseController
  def update_profile
    UpdateUserProfileForm.new(user_params)
    if current_user.update(user_params)
      render_response(status: :ok, message: "User profile updated", data: { user: current_user })
    else
      raise ActiveRecord::RecordInvalid, "Error when updating user profile"
    end
  end

  def update_avatar
    UpdateUserAvatarForm.new(image: params[:image].original_filename, content_type: params[:image].content_type)
    url = S3UploadService.upload(params[:image], "users")
    S3UploadService.delete_by_url(current_user.image_url) unless current_user.image_url.nil?
    if current_user.update(image_url: url)
      render_response(status: :ok, message: "User profile updated", data: { user: current_user })
    else
      raise ActiveRecord::RecordInvalid, "Error when updating user avatar"
    end
  end

  def user_params
    params.permit(:first_name, :last_name, :email, :date_of_birth, :gender, :phone_number, :bio, :password, :image,)
  end
end
