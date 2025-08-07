# frozen_string_literal: true

class Authentication::ConfirmationsController < Devise::ConfirmationsController
  layout "authentication"

  # GET /resource/confirmation/new
  def new
    super
  end

  # POST /resource/confirmation
  def create
    self.resource = resource_class.send_confirmation_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      flash[:alert] = "Please check your email to confirm your email address"
      redirect_to new_user_session_path, status: :see_other
    else
      flash[:alert] = resource.errors.full_messages.join("\n")
      redirect_to new_user_session_path, status: :see_other
    end
  end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    yield resource if block_given?

    if resource.errors.empty?
      set_flash_message!(:notice, :confirmed)
      flash[:alert] = "Confirmed account. Please log in"
      redirect_to new_user_session_path, status: :see_other
    else
      flash[:alert] = resource.errors.full_messages.join("\n")
      redirect_to new_user_session_path, status: :see_other
    end
  end

  # protected

  # The path used after resending confirmation instructions.
  # def after_resending_confirmation_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  # The path used after confirmation.
  # def after_confirmation_path_for(resource_name, resource)
  #   super(resource_name, resource)
  # end
end
