class Color < ApplicationRecord
  # Validation
  validates :name, presence: true, uniqueness: true
  validates :hex_code, presence: true

  # Soft Delete
  acts_as_paranoid
end
