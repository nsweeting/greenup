module Decorators
  class TaxLine
    include Decorator

    validate :validate_tax_rate

    decorate :name, from: :tax_rate
    decorate :amount, from: :tax_rate

    delegate :tax_rate, to: :object

    private

    def validate_tax_rate
      return if object.tax_rate.present?
      errors.add(:tax_rate)
    end
  end
end
