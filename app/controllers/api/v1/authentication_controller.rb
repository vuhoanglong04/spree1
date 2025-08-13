class Api::V1::AuthenticationController < Api::BaseController
  skip_before_action :authenticate_api, only: [:login]

  # POST api/v1/auth/login
  def login
    LoginService.new(email: params[:email], password: params[:password]) # Validation
    user = User.find_by(email: params[:email].strip.downcase)
    if user.valid_password?(params[:password])
      sign_in(user)
      token = request.env['warden-jwt_auth.token']
      refresh_token = user.jwt_refresh_tokens.create!.token
      render_response(status: 201, message: "Login successful", data: { access_token: token, refresh_token: refresh_token })
    else
      raise AuthenticationError, "Email or password incorrect"
    end
  end

  def logout
    token = request.headers['Authorization']&.split(' ')&.last
    payload = Warden::JWTAuth::TokenDecoder.new.call(token)
    jti = payload['jti']
    JwtDenyList.create!(jti: jti, expired_at: payload['exp'])
    sign_out(current_user)
    render_response(status: 200, message: "Logout successful")
  end

  def refresh
    refresh_token = JwtRefreshToken.find_by(token: params[:refresh_token])
    if refresh_token && DateTime.now < refresh_token.expired_at
      user = User.find(refresh_token.user_id)
      token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil)[0]
      sign_in(user)
      refresh_token.destroy!
      refresh_token = user.jwt_refresh_tokens.create!.token
      render_response(status: 200, message: "Refresh Successfully", data: { access_token: token, refresh_token: refresh_token })
    else
      raise AuthenticationError, "Invalid refresh token"
    end
  end

  def testToken
    render_response(status: 200, message: "OK", data: "KOKOKOK")

  end
end
