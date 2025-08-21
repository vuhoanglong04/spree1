class SendPasswordOauth2Mailer < ApplicationMailer
  def send_password_oauth2_email(user, password)
    @user = user
    @password = password
    mail(to: @user.email,
         subject: 'Thanks for signing up for our amazing app. This is your password')
  end
end
