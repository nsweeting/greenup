class ShippingCarrier < ApplicationRecord
  has_many :shipping_services

  alias services shipping_services

  validates :name, presence: true
end
