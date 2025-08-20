class Api::BaseController < ActionController::API
  before_action :authenticate_api
  include ResponseHandler
  include ExceptionHandler

  def authenticate_api
    token = request.headers['Authorization']&.split(' ')&.last
    if !token.present? || token.split('.').size != 3
      raise AuthenticationError, "Invalid token"
    end
    begin
      payload = Warden::JWTAuth::TokenDecoder.new.call(token)
      user = User.find_by(id: payload['sub'])
      raise AuthenticationError, "User not found" if user.nil?
      raise AuthenticationError, "Token revoked" if JwtRedisDenylist.jwt_revoked?(payload, user)
    rescue JWT::DecodeError => e
      raise AuthenticationError, "Invalid token"
    end
  end

end
