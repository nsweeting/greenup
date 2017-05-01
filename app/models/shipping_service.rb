class ShippingService < ApplicationRecord
  belongs_to :shipping_carrier

  alias carrier shipping_carrier

  validates :name, presence: true
end
