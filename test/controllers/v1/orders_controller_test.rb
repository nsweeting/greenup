require 'test_helper'
require 'controllers/test_helper'

module V1
  class OrdersControllerTest < ActionDispatch::IntegrationTest
    # Orders CREATE tests

    test 'post orders#create' do
      member = create(:member)
      header = valid_headers(member)
      assert_difference 'member.account.orders.count' do
        post orders_url, params: valid_order, headers: header
      end
      assert_response :created
      assert_serializer 'V1::OrderSerializer'
    end

    test 'post orders#create without auth' do
      get orders_url, params: valid_order
      assert_response :unauthorized
    end

    test 'post orders#create with expired auth' do
      member = create(:member)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      post orders_url, params: valid_order, headers: header
      assert_response :unauthorized
    end

    test 'post orders#create without auth scope' do
      member = create(:member, role: :basic)
      header = valid_headers(member)
      get orders_url, params: valid_order, headers: header
      assert_response :forbidden
    end

    test 'post orders#create with auth scope' do
      member = create(:member, role: :basic, scopes: ['orders/write'])
      header = valid_headers(member)
      assert_difference 'member.account.orders.count' do
        post orders_url, params: valid_order, headers: header
      end
      assert_response :created
      assert_serializer 'V1::OrderSerializer'
    end

    # Orders INDEX tests

    test 'get orders#index' do
      member = create(:member)
      create_list(:order, 3, account: member.account)
      header = valid_headers(member)
      get orders_url, headers: header
      assert_response :ok
      assert_serializer 'ActiveModel::Serializer::CollectionSerializer'
    end

    test 'get orders#index without auth' do
      get orders_url
      assert_response :unauthorized
    end

    test 'get orders#index with expired auth' do
      member = create(:member)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      get orders_url, headers: header
      assert_response :unauthorized
    end

    test 'get orders#index without auth scope' do
      member = create(:member, role: :basic)
      create_list(:order, 3, account: member.account)
      header = valid_headers(member)
      get orders_url, headers: header
      assert_response :forbidden
    end

    test 'get orders#index with auth scope' do
      member = create(:member, role: :basic, scopes: ['orders/read'])
      create_list(:order, 3, account: member.account)
      header = valid_headers(member)
      get orders_url, headers: header
      assert_response :ok
      assert_serializer 'ActiveModel::Serializer::CollectionSerializer'
    end

    # Orders SHOW tests

    test 'get order#show' do
      member = create(:member)
      province = create(:province)
      address = Address.new(first_name: 'test',last_name: 'test',address_1: 'test',city: 'test',postal_code: 'M4K 2L7',province: province,country: province.country)
      order = create(:order, account: member.account, billing_address_attributes: address.attributes)
      header = valid_headers(member)
      get order_url(order.id), headers: header
      assert_response :ok
      assert_serializer 'V1::OrderSerializer'
    end

    test 'get orders#show without auth' do
      order = create(:order)
      get order_url(order.id)
      assert_response :unauthorized
    end

    test 'get orders#show with expired auth' do
      member = create(:member)
      order = create(:order, account: member.account)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      get order_url(order.id), headers: header
      assert_response :unauthorized
    end

    test 'get orders#show without auth scope' do
      member = create(:member, role: :basic)
      order = create(:order, account: member.account)
      header = valid_headers(member)
      get order_url(order.id), headers: header
      assert_response :forbidden
    end

    test 'get orders#show with auth scope' do
      member = create(:member, role: :basic, scopes: ['orders/read'])
      order = create(:order, account: member.account)
      header = valid_headers(member)
      get order_url(order.id), headers: header
      assert_response :ok
      assert_serializer 'V1::OrderSerializer'
    end

    # Members UPDATE tests

    test 'patch orders#update' do
      member = create(:member)
      order = create(:order, account: member.account)
      header = valid_headers(member)
      patch order_url(order.id), params: { order: { email: 'new@email.com' } }, headers: header
      assert_equal 'new@email.com', order.reload.email
      assert_response :ok
    end

    test 'patch orders#update without auth' do
      order = create(:order)
      patch order_url(order.id), params: { order: { email: 'new@email.com' } }
      assert_response :unauthorized
    end

    test 'patch orders#update with expired auth' do
      member = create(:member)
      order = create(:order, account: member.account)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      patch order_url(order.id), params: { order: { email: 'new@email.com' } }, headers: header
      assert_response :unauthorized
    end

    test 'patch orders#update without auth scope' do
      member = create(:member, role: :basic)
      order = create(:order, account: member.account)
      header = valid_headers(member)
      patch order_url(order.id), params: { order: { email: 'new@email.com' } }, headers: header
      assert_response :forbidden
    end

    test 'patch members#update with auth scope' do
      member = create(:member, role: :basic, scopes: ['orders/write'])
      order = create(:order, account: member.account)
      header = valid_headers(member)
      patch order_url(order.id), params: { order: { email: 'new@email.com' } }, headers: header
      assert_equal 'new@email.com', order.reload.email
      assert_response :ok
    end

    # Members DESTROY tests

    test 'delete orders#destroy' do
      member = create(:member)
      order = create(:order, account: member.account)
      header = valid_headers(member)
      assert_difference 'member.account.orders.count', -1 do
        delete order_url(order.id), headers: header
      end
      assert_response :no_content
    end

    test 'delete orders#destroy without auth' do
      order = create(:order)
      delete order_url(order.id)
      assert_response :unauthorized
    end

    test 'delete orders#destroy with expired auth' do
      member = create(:member)
      order = create(:order, account: member.account)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      delete order_url(order.id), headers: header
      assert_response :unauthorized
    end

    test 'delete orders#destroy without auth scope' do
      member = create(:member, role: :basic)
      order = create(:order, account: member.account)
      header = valid_headers(member)
      delete order_url(order.id), headers: header
      assert_response :forbidden
    end

    test 'delete members#destroy with auth scope' do
      member = create(:member, role: :basic, scopes: ['orders/delete'])
      order = create(:order, account: member.account)
      header = valid_headers(member)
      assert_difference 'member.account.orders.count', -1 do
        delete order_url(order.id), headers: header
      end
      assert_response :no_content
    end

    private

    def valid_order
      order = Order.new(email: 'test@test.com')
      { order: order.attributes }
    end
  end
end
