module Calculators
  class Order
    include Calculator

    calculate :total_line_items_price_cents
    calculate :subtotal_price_cents
    calculate :total_tax_cents
    calculate :total_discounts_cents

    private

    def total_line_items_price_cents
      sum_line_items
    end

    def subtotal_price_cents
      sum_line_items
    end

    def total_tax_cents
      @total_tax_cents ||= object.tax_lines.sum(:price_cents)
    end

    def total_discounts_cents
      @total_discounts_cents ||= object.line_items.sum(:total_discount_cents)
    end

    def sum_line_items
      @sum_line_items ||= object.line_items.sum('price_cents * quantity')
    end
  end
end
