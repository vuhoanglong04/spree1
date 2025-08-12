class Api::V1::AuthenticationController < Api::BaseController
  # POST api/v1/auth/login
  def login
    LoginService.new(email: params[:email], password: params[:password])
  end
  def checkToken
    # user = User.find_by(email: params[:email])
    # user.jwt_refresh_tokens.matching_token?(params[:token])
    auth_header = request.headers['Authorization']
  end

end
