class JwtRedisDenylist
  def self.jwt_revoked?(payload, user)
    REDIS.exists?("jwt:#{payload['jti']}")
  end

  def self.revoke_jwt(payload, user)
    REDIS.set("jwt:#{payload['jti']}", true, ex: payload['exp'].to_i - Time.now.to_i)
  end
end
