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

    if valid_items.empty?
      errors.add(:order_items, "must contain at least one item")
    end

    # Optional: check that each valid item has required fields
    valid_items.each_with_index do |item, index|
      if item.product_variant_id.blank? || item.quantity.blank? || item.price.blank?
        errors.add(:order_items, "item ##{index + 1} is incomplete")
      end
    end
  end
end
