require 'test_helper'
require 'controllers/test_helper'

module V1
  class ShippingMethodsControllerTest < ActionDispatch::IntegrationTest
    # ShippingMethods CREATE tests

    test 'post shipping_methods#create' do
      member = create(:member)
      header = valid_headers(member)
      assert_difference 'member.account.shipping_methods.count' do
        post shipping_methods_url, params: valid_shipping_method(member.account), headers: header
      end
      assert_response :created
      assert_serializer 'V1::ShippingMethodSerializer'
    end

    test 'post shipping_methods#create without auth' do
      member = create(:member)
      get shipping_methods_url, params: valid_shipping_method(member.account)
      assert_response :unauthorized
    end

    test 'post shipping_methods#create with expired auth' do
      member = create(:member)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      post shipping_methods_url, params: valid_shipping_method(member.account), headers: header
      assert_response :unauthorized
    end

    test 'post shipping_methods#create without auth scope' do
      member = create(:member, role: :basic)
      header = valid_headers(member)
      get shipping_methods_url, params: valid_shipping_method(member.account), headers: header
      assert_response :forbidden
    end

    test 'post shipping_methods#create with auth scope' do
      member = create(:member, role: :basic, scopes: ['shipping_methods/write'])
      header = valid_headers(member)
      assert_difference 'member.account.shipping_methods.count' do
        post shipping_methods_url, params: valid_shipping_method(member.account), headers: header
      end
      assert_response :created
      assert_serializer 'V1::ShippingMethodSerializer'
    end

    # ShippingMethods INDEX tests

    test 'get shipping_methods#index' do
      member = create(:member)
      create_list(:shipping_method, 3, account: member.account)
      header = valid_headers(member)
      get shipping_methods_url, headers: header
      assert_response :ok
      assert_serializer 'ActiveModel::Serializer::CollectionSerializer'
    end

    test 'get shipping_methods#index without auth' do
      get shipping_methods_url
      assert_response :unauthorized
    end

    test 'get shipping_methods#index with expired auth' do
      member = create(:member)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      get shipping_methods_url, headers: header
      assert_response :unauthorized
    end

    test 'get shipping_methods#index without auth scope' do
      member = create(:member, role: :basic)
      create_list(:shipping_method, 3, account: member.account)
      header = valid_headers(member)
      get shipping_methods_url, headers: header
      assert_response :forbidden
    end

    test 'get shipping_methods#index with auth scope' do
      member = create(:member, role: :basic, scopes: ['shipping_methods/read'])
      create_list(:shipping_method, 3, account: member.account)
      header = valid_headers(member)
      get shipping_methods_url, headers: header
      assert_response :ok
      assert_serializer 'ActiveModel::Serializer::CollectionSerializer'
    end

    # ShippingMethods SHOW tests

    test 'get shipping_method#show' do
      member = create(:member)
      shipping_method = create(:shipping_method, account: member.account)
      header = valid_headers(member)
      get shipping_method_url(shipping_method.id), headers: header
      assert_response :ok
      assert_serializer 'V1::ShippingMethodSerializer'
    end

    test 'get shipping_methods#show without auth' do
      shipping_method = create(:shipping_method)
      get shipping_method_url(shipping_method.id)
      assert_response :unauthorized
    end

    test 'get shipping_methods#show with expired auth' do
      member = create(:member)
      shipping_method = create(:shipping_method, account: member.account)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      get shipping_method_url(shipping_method.id), headers: header
      assert_response :unauthorized
    end

    test 'get shipping_methods#show without auth scope' do
      member = create(:member, role: :basic)
      shipping_method = create(:shipping_method, account: member.account)
      header = valid_headers(member)
      get shipping_method_url(shipping_method.id), headers: header
      assert_response :forbidden
    end

    test 'get shipping_methods#show with auth scope' do
      member = create(:member, role: :basic, scopes: ['shipping_methods/read'])
      shipping_method = create(:shipping_method, account: member.account)
      header = valid_headers(member)
      get shipping_method_url(shipping_method.id), headers: header
      assert_response :ok
      assert_serializer 'V1::ShippingMethodSerializer'
    end

    # Members UPDATE tests

    test 'patch shipping_methods#update' do
      member = create(:member)
      shipping_method = create(:shipping_method, account: member.account)
      header = valid_headers(member)
      patch shipping_method_url(shipping_method.id), params: { shipping_method: { name: 'new' } }, headers: header
      assert_equal 'new', shipping_method.reload.name
      assert_response :ok
    end

    test 'patch shipping_methods#update without auth' do
      shipping_method = create(:shipping_method)
      patch shipping_method_url(shipping_method.id), params: { shipping_method: { name: 'new' } }
      assert_response :unauthorized
    end

    test 'patch shipping_methods#update with expired auth' do
      member = create(:member)
      shipping_method = create(:shipping_method, account: member.account)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      patch shipping_method_url(shipping_method.id), params: { shipping_method: { name: 'new' } }, headers: header
      assert_response :unauthorized
    end

    test 'patch shipping_methods#update without auth scope' do
      member = create(:member, role: :basic)
      shipping_method = create(:shipping_method, account: member.account)
      header = valid_headers(member)
      patch shipping_method_url(shipping_method.id), params: { shipping_method: { name: 'new' } }, headers: header
      assert_response :forbidden
    end

    test 'patch members#update with auth scope' do
      member = create(:member, role: :basic, scopes: ['shipping_methods/write'])
      shipping_method = create(:shipping_method, account: member.account)
      header = valid_headers(member)
      patch shipping_method_url(shipping_method.id), params: { shipping_method: { name: 'new' } }, headers: header
      assert_equal 'new', shipping_method.reload.name
      assert_response :ok
    end

    # Members DESTROY tests

    test 'delete shipping_methods#destroy' do
      member = create(:member)
      shipping_method = create(:shipping_method, account: member.account)
      header = valid_headers(member)
      assert_difference 'member.account.shipping_methods.count', -1 do
        delete shipping_method_url(shipping_method.id), headers: header
      end
      assert_response :no_content
    end

    test 'delete shipping_methods#destroy without auth' do
      shipping_method = create(:shipping_method)
      delete shipping_method_url(shipping_method.id)
      assert_response :unauthorized
    end

    test 'delete shipping_methods#destroy with expired auth' do
      member = create(:member)
      shipping_method = create(:shipping_method, account: member.account)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      delete shipping_method_url(shipping_method.id), headers: header
      assert_response :unauthorized
    end

    test 'delete shipping_methods#destroy without auth scope' do
      member = create(:member, role: :basic)
      shipping_method = create(:shipping_method, account: member.account)
      header = valid_headers(member)
      delete shipping_method_url(shipping_method.id), headers: header
      assert_response :forbidden
    end

    test 'delete members#destroy with auth scope' do
      member = create(:member, role: :basic, scopes: ['shipping_methods/delete'])
      shipping_method = create(:shipping_method, account: member.account)
      header = valid_headers(member)
      assert_difference 'member.account.shipping_methods.count', -1 do
        delete shipping_method_url(shipping_method.id), headers: header
      end
      assert_response :no_content
    end

    private

    def valid_shipping_method(account)
      zone = create(:zone, account: account)
      shipping_service = create(:shipping_service)
      shipping_method = ShippingMethod.new(name: 'Canada Post', zone_id: zone.id, shipping_service_id: shipping_service.id)
      { shipping_method: shipping_method.attributes }
    end
  end
end
