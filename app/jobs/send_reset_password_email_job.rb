class SendResetPasswordEmailJob < ApplicationJob
  queue_as :default

  def perform(*args)
    user_id, token = args
    user = User.find_by(id: user_id)
    Devise::Mailer.reset_password_instructions(user, token).deliver_later
  end
end
