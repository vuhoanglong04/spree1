class ApplicationController < ActionController::Base
  # Pundit
  include Pundit::Authorization

  # Rescue
  rescue_from Aws::S3::Errors::ServiceError, with: :render_s3_error

  def render_s3_error(exception)
    Rails.logger.error("S3 error: #{exception.message}")
    flash[:error] = "There was a problem uploading your file. Please try again."
    redirect_back fallback_location: root_path
  end
end
