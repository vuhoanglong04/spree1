class LoginService
  include ActiveModel::Model
  attr_accessor :email, :password

  validates :email, presence: { message: "Email is required" },
            format: { with: URI::MailTo::EMAIL_REGEXP, message: "Invalid email format" }
  validates :password, presence: { message: "Password is required" }

  def initialize(attributes = {})
    super
    validate!
    handle_login
  end

  def handle_login
    user = User.find_by(email: email.strip.downcase)
    if user.valid_password?(password)
      token = JwtHelper.generate_access_token(user)
      refresh_token = user.jwt_refresh_tokens.create!
      render_response(status: 201, message: "Login successful", data: { access_token: token, refresh_token: refresh_token })
    else
      raise AuthenticationError, "Email or password incorrect"
    end
  end

end