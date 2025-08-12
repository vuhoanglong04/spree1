class JwtRefreshToken < ApplicationRecord
  attr_accessor :raw_token
  # Relationship
  belongs_to :user
  before_create :generate_and_hash_token

  # Validation
  validates :token, uniqueness: true

  def expired?
    Time.current >= expired_at
  end

  def self.matching_token?(plain_token)
    !find_by(token: Digest::SHA256.hexdigest(plain_token)).nil?
  end

  private

  def generate_and_hash_token
    self.raw_token = SecureRandom.hex(64)
    self.token = Digest::SHA256.hexdigest(raw_token)
    self.expired_at = 7.days.from_now
  end
end
