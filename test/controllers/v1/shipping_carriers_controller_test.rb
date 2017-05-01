require 'test_helper'
require 'controllers/test_helper'

module V1
  class ShippingCarriersControllerTest < ActionDispatch::IntegrationTest
    # ShippingCarriers INDEX tests

    test 'get shipping_carriers#index' do
      member = create(:member)
      create(:shipping_carrier)
      header = valid_headers(member)
      get shipping_carriers_url, headers: header
      assert_response :ok
      assert_serializer 'ActiveModel::Serializer::CollectionSerializer'
    end

    test 'get shipping_carriers#index without auth' do
      get shipping_carriers_url
      assert_response :unauthorized
    end

    test 'get shipping_carriers#index with expired auth' do
      member = create(:member)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      get shipping_carriers_url, headers: header
      assert_response :unauthorized
    end
  end
end
