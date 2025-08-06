class ApplicationController < ActionController::Base

  layout :resolve_layout
  before_action :authenticate_user!

  # Pundit
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # Rescue
  rescue_from Aws::S3::Errors::ServiceError, with: :render_s3_error

  private

  def render_s3_error(exception)
    Rails.logger.error("S3 error: #{exception.message}")
    flash[:error] = "There was a problem uploading your file. Please try again."
    redirect_back fallback_location: root_path
  end

  def resolve_layout
    if devise_controller? && (action_name == "new" || action_name == "create")
      false
    else
      "application"
    end
  end

  def user_not_authorized(exception)
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referer || root_path)
  end
end
