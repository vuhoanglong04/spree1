class LoginForm
  include ActiveModel::Model
  attr_accessor :email, :password

  validates :email, presence: { message: "Email is required" },
            format: { with: URI::MailTo::EMAIL_REGEXP, message: "Invalid email format" }
  validates :password, presence: { message: "Password is required" }

  def initialize(attributes = {})
    super
    validate!
  end
end