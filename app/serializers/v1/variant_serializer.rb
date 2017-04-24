module V1
  class VariantSerializer < ApplicationSerializer
    attributes :id, :title, :sku, :position, :grams, :price, :option1, :option2,
               :option3, :currency, :taxable, :inventory, :old_inventory, :weight,
               :weight_unit, :product_id, :created_at, :updated_at

    def price
      object.price.format
    end
  end
end
