class CustomDeviseMailer < ApplicationMailer
  default from: "longprovip2508@gmail.com"
  layout "mailer"
  # Confirmation email
  def confirmation_instructions(record, token, opts = {})
    SendConfirmationEmailJob.perform_later(record.id, token)
  end

  # Reset password email
  def reset_password_instructions(record, token, opts = {})
    SendResetPasswordEmailJob.perform_later(record.id, token)
  end
end
