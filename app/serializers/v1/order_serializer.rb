module V1
  class OrderSerializer < ApplicationSerializer
    attributes :id, :email, :closed_at, :number, :note, :gateway, :test,
               :total_price, :subtotal_price, :total_tax, :total_discounts,
               :total_line_items_price, :currency, :name, :cancelled_at,
               :processed_at, :cancel_reason, :created_at, :updated_at

    has_one :shipping_address
    has_one :billing_address
    has_one :customer
    has_many :line_items

    def total_price
      object.total_price.format
    end

    def subtotal_price
      object.subtotal_price.format
    end

    def total_tax
      object.total_tax.format
    end

    def total_discounts
      object.total_discounts.format
    end

    def total_line_items_price
      object.total_line_items_price.format
    end
  end
end
