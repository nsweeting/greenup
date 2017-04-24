class LineItem < ApplicationRecord
  belongs_to :order, touch: true
  belongs_to :variant, optional: true
  has_one :product, through: :variant
  has_one :account, through: :order

  monetize :price_cents, {
    with_model_currency: :currency,
    numericality: { greater_than: 0 }
  }
  monetize :total_discount_cents, with_model_currency: :currency

  validates :order, presence: true
  validates :title, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :grams, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  before_validation :before_validation_set_assoc_attr
  before_validation :before_validation_set_name
  before_validation :before_validation_set_grams
  before_validation :before_validation_set_price

  private

  def before_validation_set_assoc_attr
    return unless variant.present?
    self.title          = product.title
    self.vendor         = product.vendor
    self.variant_title  = variant.title
    self.taxable        = variant.taxable
  end

  def before_validation_set_name
    self.name = variant_title.present? ? "#{title} - #{variant_title}" : title
  end

  def before_validation_set_grams
    return unless variant.present?
    self.grams = quantity.to_i * variant.grams
  end

  def before_validation_set_price
    return unless variant.present?
    self.price_cents = quantity.to_i * variant.price_cents
  end
end
