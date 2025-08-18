class SignupForm
  include ActiveModel::Model
  attr_accessor :email, :password, :first_name, :last_name, :phone_number, :date_of_birth, :gender

  validates :email, presence: { message: "Email is required" },
            format: { with: URI::MailTo::EMAIL_REGEXP, message: "Invalid email format" }
  validates :password, presence: { message: "Password is required" }
  validates :first_name, presence: { message: "First name is required" }
  validates :last_name, presence: { message: "Last name is required" }
  validates :phone_number, presence: { message: "Phone number is required" }
  validates :date_of_birth, presence: { message: "Date of birth is required" }
  validates :gender, presence: { message: "Gender is required" }

  def initialize(attributes = {})
    super
    validate!
  end
end