require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  test 'that an order can be created' do
    province = create(:province)
    account = create(:account)
    zone = create(:zone, account: account, provinces_attributes: [{id: province.id}])
    tax_rate = create(:tax_rate, account: account, zone: zone)
    customer = create(:customer, account: account)
    address = create(:customer_address, addressable: customer, province: province, country: province.country)
    order = create(:order, account: account, customer: customer, shipping_address: address)
    line_item = create(:line_item, order: order)
    byebug
  end
end
