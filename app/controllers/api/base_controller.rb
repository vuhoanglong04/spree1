class Api::BaseController < ActionController::API
  before_action :authenticate_api
  include ResponseHandler
  include ExceptionHandler

  def authenticate_api
    token = request.headers['Authorization']&.split(' ')&.last
    raise AuthenticationError, "Missing token" if token.blank?

    payload = Warden::JWTAuth::TokenDecoder.new.call(token)
    jti = payload['jti']

    raise JWT::ExpiredSignature if JwtDenyList.exists?(jti: jti)
  end
end
