class UpdateUserAvatarForm
  include ActiveModel::Model
  attr_accessor :image, :content_type

  validates :image, presence: { message: "Avatar file is required" }
  validate :validate_image_type

  def initialize(attributes = {})
    super
    validate!
  end

  private

  def validate_image_type
    return if image.blank?

    allowed_types = ["image/jpeg", "image/png", "image/jpg", "image/gif"]
    unless allowed_types.include?(content_type)
      errors.add(:image, "must be a valid image format (jpg, png, gif)")
    end
  end

end