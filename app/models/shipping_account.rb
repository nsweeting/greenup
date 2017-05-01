class ShippingAccount < ApplicationRecord
  belongs_to :account
  belongs_to :shipping_carrier

  with_options presence: true do
    validates :account, :shipping_carrier
  end
end
