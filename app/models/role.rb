class Role < ApplicationRecord
  # Relationship
  has_many :users
  has_many :role_permissions, dependent: :destroy
  has_many :permissions, through: :role_permissions
  # Validation
  validates :name, presence: true, uniqueness: true
end
