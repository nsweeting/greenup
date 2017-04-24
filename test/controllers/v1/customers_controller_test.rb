require 'test_helper'
require 'controllers/test_helper'

module V1
  class CustomersControllerTest < ActionDispatch::IntegrationTest
    # Customers CREATE tests

    test 'post customers#create' do
      member = create(:member)
      header = valid_headers(member)
      assert_difference 'member.account.customers.count' do
        post customers_url, params: valid_customer, headers: header
      end
      assert_response :created
      assert_serializer 'V1::CustomerSerializer'
    end

    test 'post customers#create without auth' do
      get customers_url, params: valid_customer
      assert_response :unauthorized
    end

    test 'post customers#create with expired auth' do
      member = create(:member)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      post customers_url, params: valid_customer, headers: header
      assert_response :unauthorized
    end

    test 'post customers#create without auth scope' do
      member = create(:member, role: :basic)
      header = valid_headers(member)
      get customers_url, params: valid_customer, headers: header
      assert_response :forbidden
    end

    test 'post customers#create with auth scope' do
      member = create(:member, role: :basic, scopes: ['customers/write'])
      header = valid_headers(member)
      assert_difference 'member.account.customers.count' do
        post customers_url, params: valid_customer, headers: header
      end
      assert_response :created
      assert_serializer 'V1::CustomerSerializer'
    end

    # Customers INDEX tests

    test 'get customers#index' do
      member = create(:member)
      create_list(:customer, 3, account: member.account)
      header = valid_headers(member)
      get customers_url, headers: header
      assert_response :ok
      assert_serializer 'ActiveModel::Serializer::CollectionSerializer'
    end

    test 'get customers#index without auth' do
      get customers_url
      assert_response :unauthorized
    end

    test 'get customers#index with expired auth' do
      member = create(:member)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      get customers_url, headers: header
      assert_response :unauthorized
    end

    test 'get customers#index without auth scope' do
      member = create(:member, role: :basic)
      create_list(:customer, 3, account: member.account)
      header = valid_headers(member)
      get customers_url, headers: header
      assert_response :forbidden
    end

    test 'get customers#index with auth scope' do
      member = create(:member, role: :basic, scopes: ['customers/read'])
      create_list(:customer, 3, account: member.account)
      header = valid_headers(member)
      get customers_url, headers: header
      assert_response :ok
      assert_serializer 'ActiveModel::Serializer::CollectionSerializer'
    end

    # Customers SHOW tests

    test 'get customer#show' do
      member = create(:member)
      customer = create(:customer, account: member.account)
      header = valid_headers(member)
      get customer_url(customer.id), headers: header
      assert_response :ok
      assert_serializer 'V1::CustomerSerializer'
    end

    test 'get customers#show without auth' do
      customer = create(:customer)
      get customer_url(customer.id)
      assert_response :unauthorized
    end

    test 'get customers#show with expired auth' do
      member = create(:member)
      customer = create(:customer, account: member.account)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      get customer_url(customer.id), headers: header
      assert_response :unauthorized
    end

    test 'get customers#show without auth scope' do
      member = create(:member, role: :basic)
      customer = create(:customer, account: member.account)
      header = valid_headers(member)
      get customer_url(customer.id), headers: header
      assert_response :forbidden
    end

    test 'get customers#show with auth scope' do
      member = create(:member, role: :basic, scopes: ['customers/read'])
      customer = create(:customer, account: member.account)
      header = valid_headers(member)
      get customer_url(customer.id), headers: header
      assert_response :ok
      assert_serializer 'V1::CustomerSerializer'
    end

    # Members UPDATE tests

    test 'patch customers#update' do
      member = create(:member)
      customer = create(:customer, account: member.account)
      header = valid_headers(member)
      patch customer_url(customer.id), params: { customer: { email: 'new@email.com' } }, headers: header
      assert_equal 'new@email.com', customer.reload.email
      assert_response :ok
    end

    test 'patch customers#update without auth' do
      customer = create(:customer)
      patch customer_url(customer.id), params: { customer: { email: 'new@email.com' } }
      assert_response :unauthorized
    end

    test 'patch customers#update with expired auth' do
      member = create(:member)
      customer = create(:customer, account: member.account)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      patch customer_url(customer.id), params: { customer: { email: 'new@email.com' } }, headers: header
      assert_response :unauthorized
    end

    test 'patch customers#update without auth scope' do
      member = create(:member, role: :basic)
      customer = create(:customer, account: member.account)
      header = valid_headers(member)
      patch customer_url(customer.id), params: { customer: { email: 'new@email.com' } }, headers: header
      assert_response :forbidden
    end

    test 'patch members#update with auth scope' do
      member = create(:member, role: :basic, scopes: ['customers/write'])
      customer = create(:customer, account: member.account)
      header = valid_headers(member)
      patch customer_url(customer.id), params: { customer: { email: 'new@email.com' } }, headers: header
      assert_equal 'new@email.com', customer.reload.email
      assert_response :ok
    end

    # Members DESTROY tests

    test 'delete customers#destroy' do
      member = create(:member)
      customer = create(:customer, account: member.account)
      header = valid_headers(member)
      assert_difference 'member.account.customers.count', -1 do
        delete customer_url(customer.id), headers: header
      end
      assert_response :no_content
    end

    test 'delete customers#destroy without auth' do
      customer = create(:customer)
      delete customer_url(customer.id)
      assert_response :unauthorized
    end

    test 'delete customers#destroy with expired auth' do
      member = create(:member)
      customer = create(:customer, account: member.account)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      delete customer_url(customer.id), headers: header
      assert_response :unauthorized
    end

    test 'delete customers#destroy without auth scope' do
      member = create(:member, role: :basic)
      customer = create(:customer, account: member.account)
      header = valid_headers(member)
      delete customer_url(customer.id), headers: header
      assert_response :forbidden
    end

    test 'delete members#destroy with auth scope' do
      member = create(:member, role: :basic, scopes: ['customers/delete'])
      customer = create(:customer, account: member.account)
      header = valid_headers(member)
      assert_difference 'member.account.customers.count', -1 do
        delete customer_url(customer.id), headers: header
      end
      assert_response :no_content
    end

    private

    def valid_customer
      customer = Customer.new(email: 'test@test.com')
      { customer: customer.attributes }
    end
  end
end
