class Api::V1::AuthenticationController < Api::BaseController
  skip_before_action :authenticate_api, only: [:login, :refresh, :signup]

  # POST api/v1/auth/login
  def login
    LoginForm.new(email: params[:email], password: params[:password]) # Validation
    user = User.find_by(email: params[:email].strip.downcase)
    raise ActiveRecord::RecordNotFound, "User not found" if user.blank?
    if user.valid_password?(params[:password])
      sign_in(user)
      jwt_payload = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil)
      token = jwt_payload[0]
      refresh_token = user.jwt_refresh_tokens.create!.token
      render_response(status: 201, message: "Login successful", data: { user: ActiveModelSerializers::SerializableResource.new(user, serializer: UserSerializer),
                                                                        access_token: token,
                                                                        refresh_token: refresh_token })
    else
      raise AuthenticationError, "Email or password incorrect"
    end
  end

  def signup
    SignupForm.new(signup_params)
    user = User.new(signup_params)
    user.image_url = Faker::Avatar.image
    user.role_id = 3
    user.skip_confirmation!
    if user.save
      sign_in(user)
      token = request.env['warden-jwt_auth.token']
      refresh_token = user.jwt_refresh_tokens.create!.token
      render_response(status: 201, message: "Signup successful", data: { user: ActiveModelSerializers::SerializableResource.new(user, serializer: UserSerializer),
                                                                         access_token: token,
                                                                         refresh_token: refresh_token })
    else
      raise ActiveRecord::RecordInvalid, user
    end
  end

  def logout
    token = request.headers['Authorization']&.split(' ')&.last
    payload = Warden::JWTAuth::TokenDecoder.new.call(token)
    JwtRedisDenylist.revoke_jwt(payload, current_user)
    sign_out(current_user)
    render_response(status: 200, message: "Logout successful")
  end

  def refresh
    refresh_token = JwtRefreshToken.find_by(token: params[:refresh_token])
    if refresh_token && DateTime.now < refresh_token.expired_at
      user = User.find(refresh_token.user_id)
      sign_in(user)
      refresh_token.destroy!
      refresh_token = user.jwt_refresh_tokens.create!.token
      render_response(status: 200, message: "Refresh Successfully", data: { access_token: token, refresh_token: refresh_token })
    else
      raise AuthenticationError, "Invalid refresh token"
    end
  end

  private

  def login_params
    params.permit(:email, :password)
  end

  def signup_params
    params.permit(:email, :password, :first_name, :last_name, :phone_number, :date_of_birth, :gender)
  end
end
