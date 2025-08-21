class User < ApplicationRecord

  # Relationship
  belongs_to :role
  has_many :jwt_refresh_tokens, dependent: :destroy
  has_many :orders
  # Nested Attribute

  # Soft Delete
  acts_as_paranoid

  # Devise
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :trackable,
         :confirmable,
         :jwt_authenticatable,
         :omniauthable, omniauth_providers: [:google_oauth2],
         jwt_revocation_strategy: JwtRedisDenylist

  # Validation
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :phone_number, presence: true
  validates :date_of_birth, presence: true
  validates :gender, presence: true
  validates :email, uniqueness: true, presence: true, on: :create, format: { with: Devise.email_regexp }
  validates :image_url, presence: true, on: :create
  validates :password, confirmation: true, length: { within: Devise.password_length }, on: :create

  # @return [TrueClass, FalseClass]
  def password_required?
    new_record? || password.present? || password_confirmation.present?
  end

  def has_permission?(subject, action)
    role.permissions.exists?(subject: subject, action: action)
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.image_url = auth.info.image
    end
  end
end
