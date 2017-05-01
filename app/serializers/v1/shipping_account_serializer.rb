module V1
  class ShippingAccountSerializer < ApplicationSerializer
    attributes :id, :credentials, :created_at, :updated_at

    belongs_to :shipping_carrier
  end
end
