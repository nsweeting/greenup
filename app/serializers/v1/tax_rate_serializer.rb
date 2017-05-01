module V1
  class TaxRateSerializer < ApplicationSerializer
    attributes :id, :name, :amount, :created_at, :updated_at

    belongs_to :zone
  end
end
