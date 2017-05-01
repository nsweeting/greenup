module V1
  class ShippingMethodSerializer < ApplicationSerializer
    attributes :id, :name, :created_at, :updated_at

    belongs_to :shipping_service
    belongs_to :zone
  end
end
