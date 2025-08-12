module JwtHelper
  def self.generate_access_token(user)
    Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
  end

  def self.decode_access_token(token)
    Warden::JWTAuth::TokenDecoder.new.call(token)
  rescue JWT::DecodeError => e
    Rails.logger.error("JWT Decode Error: #{e.message}")
    nil
  end
end
