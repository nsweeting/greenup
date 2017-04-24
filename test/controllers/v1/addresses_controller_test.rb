require 'test_helper'
require 'controllers/test_helper'

module V1
  class AddressesControllerTest < ActionDispatch::IntegrationTest
    # Addresses CREATE tests

    test 'post addresses#create' do
      member = create(:member)
      customer = create(:customer, account: member.account)
      header = valid_headers(member)
      assert_difference 'member.account.addresses.count' do
        post customer_addresses_url(customer.id), params: valid_address, headers: header
      end
      assert_response :created
      assert_serializer 'V1::AddressSerializer'
    end

    test 'post addresses#create without auth' do
      customer = create(:customer)
      get customer_addresses_url(customer.id), params: valid_address
      assert_response :unauthorized
    end

    test 'post addresses#create with expired auth' do
      member = create(:member)
      customer = create(:customer, account: member.account)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      post customer_addresses_url(customer.id), params: valid_address, headers: header
      assert_response :unauthorized
    end

    test 'post addresses#create without auth scope' do
      member = create(:member, role: :basic)
      customer = create(:customer, account: member.account)
      header = valid_headers(member)
      get customer_addresses_url(customer.id), params: valid_address, headers: header
      assert_response :forbidden
    end

    test 'post addresses#create with auth scope' do
      member = create(:member, role: :basic, scopes: ['addresses/write'])
      customer = create(:customer, account: member.account)
      header = valid_headers(member)
      assert_difference 'member.account.addresses.count' do
        post customer_addresses_url(customer.id), params: valid_address, headers: header
      end
      assert_response :created
      assert_serializer 'V1::AddressSerializer'
    end

    # Addresses INDEX tests

    test 'get addresses#index' do
      member = create(:member)
      customer = create(:customer, account: member.account)
      create_list(:customer_address, 3, addressable: customer)
      header = valid_headers(member)
      get customer_addresses_url(customer.id), headers: header
      assert_response :ok
      assert_serializer 'ActiveModel::Serializer::CollectionSerializer'
    end

    test 'get addresses#index without auth' do
      get customer_addresses_url(1)
      assert_response :unauthorized
    end

    test 'get addresses#index with expired auth' do
      member = create(:member)
      customer = create(:customer, account: member.account)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      get customer_addresses_url(customer.id), headers: header
      assert_response :unauthorized
    end

    test 'get addresses#index without auth scope' do
      member = create(:member, role: :basic)
      customer = create(:customer, account: member.account)
      create_list(:customer_address, 3, addressable: customer)
      header = valid_headers(member)
      get customer_addresses_url(customer.id), headers: header
      assert_response :forbidden
    end

    test 'get addresses#index with auth scope' do
      member = create(:member, role: :basic, scopes: ['addresses/read'])
      customer = create(:customer, account: member.account)
      create_list(:customer_address, 3, addressable: customer)
      header = valid_headers(member)
      get customer_addresses_url(customer.id), headers: header
      assert_response :ok
      assert_serializer 'ActiveModel::Serializer::CollectionSerializer'
    end

    # Addresses SHOW tests

    test 'get address#show' do
      member = create(:member)
      customer = create(:customer, account: member.account)
      address = create(:customer_address, addressable: customer)
      header = valid_headers(member)
      get customer_address_url(customer.id, address.id), headers: header
      assert_response :ok
      assert_serializer 'V1::AddressSerializer'
    end

    test 'get addresses#show without auth' do
      customer = create(:customer)
      address = create(:customer_address, addressable: customer)
      get customer_address_url(customer.id, address.id)
      assert_response :unauthorized
    end

    test 'get addresses#show with expired auth' do
      member = create(:member)
      customer = create(:customer, account: member.account)
      address = create(:customer_address, addressable: customer)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      get customer_address_url(customer.id, address.id), headers: header
      assert_response :unauthorized
    end

    test 'get addresses#show without auth scope' do
      member = create(:member, role: :basic)
      customer = create(:customer, account: member.account)
      address = create(:customer_address, addressable: customer)
      header = valid_headers(member)
      get customer_address_url(customer.id, address.id), headers: header
      assert_response :forbidden
    end

    test 'get addresses#show with auth scope' do
      member = create(:member, role: :basic, scopes: ['addresses/read'])
      customer = create(:customer, account: member.account)
      address = create(:customer_address, addressable: customer)
      header = valid_headers(member)
      get customer_address_url(customer.id, address.id), headers: header
      assert_response :ok
      assert_serializer 'V1::AddressSerializer'
    end

    # Members UPDATE tests

    test 'patch addresses#update' do
      member = create(:member)
      customer = create(:customer, account: member.account)
      address = create(:customer_address, addressable: customer)
      header = valid_headers(member)
      patch customer_address_url(customer.id, address.id), params: { address: { address_1: 'new' } }, headers: header
      assert_equal 'new', address.reload.address_1
      assert_response :ok
    end

    test 'patch addresses#update without auth' do
      customer = create(:customer)
      address = create(:customer_address, addressable: customer)
      patch customer_address_url(customer.id, address.id), params: { address: { address_1: 'new' } }
      assert_response :unauthorized
    end

    test 'patch addresses#update with expired auth' do
      member = create(:member)
      customer = create(:customer, account: member.account)
      address = create(:customer_address, addressable: customer)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      patch customer_address_url(customer.id,  address.id), params: { address: { address_1: 'new' } }, headers: header
      assert_response :unauthorized
    end

    test 'patch addresses#update without auth scope' do
      member = create(:member, role: :basic)
      customer = create(:customer, account: member.account)
      address = create(:customer_address, addressable: customer)
      header = valid_headers(member)
      patch customer_address_url(customer.id, address.id), params: { address: { address_1: 'new' } }, headers: header
      assert_response :forbidden
    end

    test 'patch members#update with auth scope' do
      member = create(:member, role: :basic, scopes: ['addresses/write'])
      customer = create(:customer, account: member.account)
      address = create(:customer_address, addressable: customer)
      header = valid_headers(member)
      patch customer_address_url(customer.id, address.id), params: { address: { address_1: 'new' } }, headers: header
      assert_equal 'new', address.reload.address_1
      assert_response :ok
    end

    # Members DESTROY tests

    test 'delete addresses#destroy' do
      member = create(:member)
      customer = create(:customer, account: member.account)
      address = create(:customer_address, addressable: customer)
      header = valid_headers(member)
      assert_difference 'member.account.addresses.count', -1 do
        delete customer_address_url(customer.id, address.id), headers: header
      end
      assert_response :no_content
    end

    test 'delete addresses#destroy without auth' do
      customer = create(:customer)
      address = create(:customer_address, addressable: customer)
      delete customer_address_url(customer.id, address.id)
      assert_response :unauthorized
    end

    test 'delete addresses#destroy with expired auth' do
      member = create(:member)
      customer = create(:customer, account: member.account)
      address = create(:customer_address, addressable: customer)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      delete customer_address_url(customer.id, address.id), headers: header
      assert_response :unauthorized
    end

    test 'delete addresses#destroy without auth scope' do
      member = create(:member, role: :basic)
      customer = create(:customer, account: member.account)
      address = create(:customer_address, addressable: customer)
      header = valid_headers(member)
      delete customer_address_url(customer.id, address.id), headers: header
      assert_response :forbidden
    end

    test 'delete members#destroy with auth scope' do
      member = create(:member, role: :basic, scopes: ['addresses/delete'])
      customer = create(:customer, account: member.account)
      address = create(:customer_address, addressable: customer)
      header = valid_headers(member)
      assert_difference 'member.account.addresses.count', -1 do
        delete customer_address_url(customer.id, address.id), headers: header
      end
      assert_response :no_content
    end

    private

    def valid_address
      province = create(:province)
      address = Address.new(
        first_name: 'test',
        last_name: 'test',
        address_1: 'test',
        city: 'test',
        postal_code: 'M4K 2L7',
        province: province,
        country: province.country
      )
      { address: address.attributes }
    end
  end
end
