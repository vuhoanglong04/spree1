class DeleteExpiredRefreshTokenJob < ApplicationJob
  queue_as :default

  def perform(*args)
    JwtRefreshToken.find_each(batch_size: 50) do |token|
      token.destroy if token.expired_at < Time.current
    end
  end
end
