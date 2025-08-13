class JwtRefreshToken < ApplicationRecord
  # Relationship
  belongs_to :user

  # Validation
  validates :token, uniqueness: true

  # Callback
  before_create :generate_token, :set_expiration

  private

  def generate_token
    self.token = SecureRandom.hex(64)
  end

  def set_expiration
    self.expired_at = 7.days.from_now
  end
end
