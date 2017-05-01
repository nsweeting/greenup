class Order < ApplicationRecord
  include Addressable

  belongs_to :account
  belongs_to :customer, optional: true
  has_many :line_items
  has_many :tax_lines, through: :line_items

  has_address :shipping
  has_address :billing

  monetize :total_price_cents, :subtotal_price_cents, :total_tax_cents,
           :total_discounts_cents, :total_line_items_price_cents,
           with_model_currency: :currency

  accepts_nested_attributes_for :customer, :shipping_address, :billing_address

  alias tax_address shipping_address

  with_options presence: true do
    validates :account, :number, :name
  end
  validate :validate_customer_account

  before_validation { Decorators::Order.assign!(self) }
  before_save { Calculators::Order.assign!(self) }

  def tax_zones
    @tax_zones ||= account.zones.matches(tax_address)
  end

  def calculator
    @calculator ||= OrderCalculator.new(self)
  end

  private

  def validate_customer_account
    return unless customer.present?
    return if customer.account == account
    errors.add(:customer, 'must belong to your account')
  end
end
