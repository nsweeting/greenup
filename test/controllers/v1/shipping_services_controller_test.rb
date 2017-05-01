require 'test_helper'
require 'controllers/test_helper'

module V1
  class ShippingServicesControllerTest < ActionDispatch::IntegrationTest
    # ShippingServices INDEX tests

    test 'get shipping_services#index' do
      member = create(:member)
      service = create(:shipping_service)
      header = valid_headers(member)
      get shipping_carrier_services_url(service.carrier.id), headers: header
      assert_response :ok
      assert_serializer 'ActiveModel::Serializer::CollectionSerializer'
    end

    test 'get shipping_services#index without auth' do
      service = create(:shipping_service)
      get shipping_carrier_services_url(service.carrier.id)
      assert_response :unauthorized
    end

    test 'get shipping_services#index with expired auth' do
      member = create(:member)
      service = create(:shipping_service)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      get shipping_carrier_services_url(service.carrier.id), headers: header
      assert_response :unauthorized
    end
  end
end
