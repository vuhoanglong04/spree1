class Api::BaseController < ActionController::API
  before_action :authenticate_api
  include ResponseHandler
  include ExceptionHandler

  def authenticate_api
    token = request.headers['Authorization']&.split(' ')&.last
    raise AuthenticationError, "Missing token" if token.blank?

    payload = Warden::JWTAuth::TokenDecoder.new.call(token)
    jti = payload['jti']

    if JwtDenyList.exists?(jti: jti)
      raise AuthenticationError, "Token is invalid"
    end
  end
end
