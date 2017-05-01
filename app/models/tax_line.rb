class TaxLine < ApplicationRecord
  attr_accessor :tax_rate

  belongs_to :taxable, polymorphic: true

  monetize :price_cents, with_model_currency: :currency

  validates :taxable, presence: true
  validates :tax_rate, presence: true
  validates_numericality_of :price

  before_validation { Decorators::TaxLine.assign!(self) }
  before_validation { Calculators::TaxLine.assign!(self) }
end
