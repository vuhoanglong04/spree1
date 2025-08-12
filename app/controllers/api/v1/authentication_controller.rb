class Api::V1::AuthenticationController < Api::BaseController
  # POST api/v1/auth/login
  def login
    user = User.find_by(email: params[:email])
    raise AuthenticationError, "User not found" if user.nil?
    if user.valid_password?(params[:password])
      token = JwtHelper.generate_access_token(user)
      refresh_token = user.jwt_refresh_tokens.create!.raw_token
      render_response(status: 201, message: "Login successful", data: { access_token: token, refresh_token: refresh_token })
    else
      raise AuthenticationError, "Email or password incorrect"
    end
  end

  def checkToken
    # user = User.find_by(email: params[:email])
    # user.jwt_refresh_tokens.matching_token?(params[:token])
    auth_header = request.headers['Authorization']
  end

end
