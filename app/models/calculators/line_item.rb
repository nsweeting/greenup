module Calculators
  class LineItem
    include Calculator

    calculate :total_grams
    calculate :total_price_cents

    private

    def total_grams
      object.quantity.to_i * object.grams.to_i
    end

    def total_price_cents
      object.quantity.to_i * object.price_cents.to_i
    end
  end
end
