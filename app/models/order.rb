class Order < ApplicationRecord
  include Addressable

  belongs_to :account
  belongs_to :customer, optional: true
  has_many :line_items

  has_address :shipping
  has_address :billing

  monetize :total_price_cents, :subtotal_price_cents, :total_tax_cents,
           :total_discounts_cents, :total_line_items_price_cents,
           with_model_currency: :currency

  accepts_nested_attributes_for :customer, :shipping_address, :billing_address

  with_options presence: true do
    validates :account, :number, :name
  end
  validate :validate_customer_account

  before_validation :before_validation_set_defaults, on: :create

  private

  def before_validation_set_defaults
    last_order = account.orders.select(:number).last&.number || 0
    self.number = last_order + 1
    self.name = "##{last_order + 1000}"
  end

  def validate_customer_account
    return unless customer.present?
    return if customer.account == account
    errors.add(:customer, 'must belong to your account')
  end
end
