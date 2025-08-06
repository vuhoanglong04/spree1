# frozen_string_literal: true

class Authentication::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  # layout false

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    self.resource = warden.authenticate(auth_options)

    if resource.nil?
      flash[:alert] = "Email or password is incorrect"
      redirect_to new_session_path(resource_name) and return
    end

    if resource.locked_at.present?
      flash[:alert] = "Your account is locked"
      redirect_to new_session_path(resource_name) and return
    end
    if resource.role == 1
      flash[:alert] = "You are not permitted"
      redirect_to new_session_path(resource_name) and return
    end
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    UserNotifierMailer.send_signup_email(resource).deliver
    yield resource if block_given?
    respond_with resource, location: after_sign_in_path_for(resource)
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
