class Order < ApplicationRecord
  # Relationship
  belongs_to :user, optional: true
  has_many :order_items
  accepts_nested_attributes_for :order_items, allow_destroy: true
  # Validation
  validates :street, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip, presence: true
  validates :phone_number, presence: true
  validates :country, presence: true
  validates :status, presence: true
  validates :total_amount, presence: true, numericality: { greater_than: 0 }
  validate :must_have_at_least_one_order_item

  private

  def must_have_at_least_one_order_item
    valid_items = order_items.reject(&:marked_for_destruction?)

    return errors.add(:order_items, "must contain at least one item") if valid_items.empty?

    valid_items.each_with_index do |item, index|
      validate_item_presence(item, index)
      validate_item_stock(item, index)
    end
  end

  private

  def validate_item_presence(item, index)
    if item.product_variant_id.blank? || item.quantity.blank? || item.price.blank?
      errors.add(:order_items, "item ##{index + 1} is incomplete")
    end
  end

  def validate_item_stock(item, index)
    return if item.product_variant.blank? || item.quantity.blank?

    if item.product_variant.stock < item.quantity
      errors.add(:order_items, "item ##{index + 1} quantity (#{item.quantity}) exceeds available stock (#{item.product_variant.stock})")
    end
  end
end
