module V1
  class LineItemSerializer < ApplicationSerializer
    attributes :id, :title, :variant_title, :vendor, :name, :grams, :quantity,
               :price, :total_discount, :currency, :taxable, :requires_shipping,
               :variant_id, :created_at, :updated_at

    def price
      object.price.format
    end

    def total_discount
      object.total_discount.format
    end
  end
end
