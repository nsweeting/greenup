module V1
  class TaxLineSerializer < ApplicationSerializer
    attributes :id, :name, :price, :rate, :created_at, :updated_at

    def price
      object.price.format
    end
  end
end
