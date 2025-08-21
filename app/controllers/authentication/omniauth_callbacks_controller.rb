# frozen_string_literal: true

class Authentication::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  def google_oauth2
    auth = request.env['omniauth.auth']

    user = User.find_or_initialize_by(email: auth.info.email)

    is_new_user = user.new_record?
    password = Devise.friendly_token[0, 20] if is_new_user

    user.assign_attributes(
      first_name:   auth.info.first_name,
      last_name:    auth.info.last_name || "#",
      image_url:    auth.info.image,
      provider:     "google",
      uid:          auth.uid,
      gender:       "male",
      date_of_birth: Date.current,
      phone_number: Faker::PhoneNumber.phone_number,
      role_id:      2
    )

    if is_new_user
      user.password = password
      user.skip_confirmation!
    end

    user.save!
    SendPasswordOauth2Mailer.send_password_oauth2_email(user, password).deliver_later if is_new_user

    sign_in_and_redirect user, event: :authentication
    set_flash_message(:notice, :success, kind: "Google") if is_navigational_format?
  end


  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end
