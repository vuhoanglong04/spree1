class Size < ApplicationRecord
  # Validation
  validates :name, presence: true, uniqueness: true
  # Soft Delete
  acts_as_paranoid
end
