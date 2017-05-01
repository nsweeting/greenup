module Calculators
  class TaxLine
    include Calculator

    calculate :price

    delegate :taxable, to: :object

    private

    def price
      object.amount * taxable.price
    end
  end
end
