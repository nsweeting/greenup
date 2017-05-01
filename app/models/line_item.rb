class LineItem < ApplicationRecord
  # ASSOCIATIONS
  belongs_to :order
  belongs_to :variant, optional: true
  has_one :product, through: :variant
  has_one :account, through: :order
  has_many :tax_lines, as: :taxable, dependent: :destroy

  # MONETIZATIONS
  monetize :price_cents, :total_price_cents, {
    with_model_currency: :currency,
    numericality: { greater_than: 0 }
  }
  monetize :total_discount_cents, with_model_currency: :currency

  # DELEGATIONS
  delegate :tax_zones, to: :order

  # VALIDATIONS
  with_options presence: true do
    validates :order, :title
  end
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :grams, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # CALLBACKS
  before_validation { Decorators::LineItem.assign!(self) }
  before_validation { Calculators::LineItem.assign!(self) }
  after_save :after_save_update_tax_lines
  after_save { Calculators::Order.update!(order) }

  def name
    variant_title.present? ? "#{title} - #{variant_title}" : title
  end

  private

  def after_save_update_tax_lines
    tax_lines.destroy_all
    return unless taxable
    tax_zones.includes(:tax_rates).each do |zone|
      zone.tax_rates.each { |rate| tax_lines.create!(tax_rate: rate) }
    end
  end
end
