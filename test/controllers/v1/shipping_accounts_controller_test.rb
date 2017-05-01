require 'test_helper'
require 'controllers/test_helper'

module V1
  class ShippingAccountsControllerTest < ActionDispatch::IntegrationTest
    # ShippingAccounts CREATE tests

    test 'post shipping_accounts#create' do
      member = create(:member)
      header = valid_headers(member)
      assert_difference 'member.account.shipping_accounts.count' do
        post shipping_accounts_url, params: valid_shipping_account(member.account), headers: header
      end
      assert_response :created
      assert_serializer 'V1::ShippingAccountSerializer'
    end

    test 'post shipping_accounts#create without auth' do
      member = create(:member)
      get shipping_accounts_url, params: valid_shipping_account(member.account)
      assert_response :unauthorized
    end

    test 'post shipping_accounts#create with expired auth' do
      member = create(:member)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      post shipping_accounts_url, params: valid_shipping_account(member.account), headers: header
      assert_response :unauthorized
    end

    test 'post shipping_accounts#create without auth scope' do
      member = create(:member, role: :basic)
      header = valid_headers(member)
      get shipping_accounts_url, params: valid_shipping_account(member.account), headers: header
      assert_response :forbidden
    end

    test 'post shipping_accounts#create with auth scope' do
      member = create(:member, role: :basic, scopes: ['shipping_accounts/write'])
      header = valid_headers(member)
      assert_difference 'member.account.shipping_accounts.count' do
        post shipping_accounts_url, params: valid_shipping_account(member.account), headers: header
      end
      assert_response :created
      assert_serializer 'V1::ShippingAccountSerializer'
    end

    # ShippingAccounts INDEX tests

    test 'get shipping_accounts#index' do
      member = create(:member)
      create_list(:shipping_account, 3, account: member.account)
      header = valid_headers(member)
      get shipping_accounts_url, headers: header
      assert_response :ok
      assert_serializer 'ActiveModel::Serializer::CollectionSerializer'
    end

    test 'get shipping_accounts#index without auth' do
      get shipping_accounts_url
      assert_response :unauthorized
    end

    test 'get shipping_accounts#index with expired auth' do
      member = create(:member)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      get shipping_accounts_url, headers: header
      assert_response :unauthorized
    end

    test 'get shipping_accounts#index without auth scope' do
      member = create(:member, role: :basic)
      create_list(:shipping_account, 3, account: member.account)
      header = valid_headers(member)
      get shipping_accounts_url, headers: header
      assert_response :forbidden
    end

    test 'get shipping_accounts#index with auth scope' do
      member = create(:member, role: :basic, scopes: ['shipping_accounts/read'])
      create_list(:shipping_account, 3, account: member.account)
      header = valid_headers(member)
      get shipping_accounts_url, headers: header
      assert_response :ok
      assert_serializer 'ActiveModel::Serializer::CollectionSerializer'
    end

    # ShippingAccounts SHOW tests

    test 'get shipping_account#show' do
      member = create(:member)
      shipping_account = create(:shipping_account, account: member.account)
      header = valid_headers(member)
      get shipping_account_url(shipping_account.id), headers: header
      assert_response :ok
      assert_serializer 'V1::ShippingAccountSerializer'
    end

    test 'get shipping_accounts#show without auth' do
      shipping_account = create(:shipping_account)
      get shipping_account_url(shipping_account.id)
      assert_response :unauthorized
    end

    test 'get shipping_accounts#show with expired auth' do
      member = create(:member)
      shipping_account = create(:shipping_account, account: member.account)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      get shipping_account_url(shipping_account.id), headers: header
      assert_response :unauthorized
    end

    test 'get shipping_accounts#show without auth scope' do
      member = create(:member, role: :basic)
      shipping_account = create(:shipping_account, account: member.account)
      header = valid_headers(member)
      get shipping_account_url(shipping_account.id), headers: header
      assert_response :forbidden
    end

    test 'get shipping_accounts#show with auth scope' do
      member = create(:member, role: :basic, scopes: ['shipping_accounts/read'])
      shipping_account = create(:shipping_account, account: member.account)
      header = valid_headers(member)
      get shipping_account_url(shipping_account.id), headers: header
      assert_response :ok
      assert_serializer 'V1::ShippingAccountSerializer'
    end

    # Members UPDATE tests

    test 'patch shipping_accounts#update' do
      member = create(:member)
      shipping_account = create(:shipping_account, account: member.account)
      header = valid_headers(member)
      patch shipping_account_url(shipping_account.id), params: { shipping_account: { credentials: { test: 'key' } } }, headers: header
      assert_equal({ 'test' => 'key' }, shipping_account.reload.credentials)
      assert_response :ok
    end

    test 'patch shipping_accounts#update without auth' do
      shipping_account = create(:shipping_account)
      patch shipping_account_url(shipping_account.id), params: { shipping_account: { credentials: { test: 'key' } } }
      assert_response :unauthorized
    end

    test 'patch shipping_accounts#update with expired auth' do
      member = create(:member)
      shipping_account = create(:shipping_account, account: member.account)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      patch shipping_account_url(shipping_account.id), params: { shipping_account: { credentials: { test: 'key' } } }, headers: header
      assert_response :unauthorized
    end

    test 'patch shipping_accounts#update without auth scope' do
      member = create(:member, role: :basic)
      shipping_account = create(:shipping_account, account: member.account)
      header = valid_headers(member)
      patch shipping_account_url(shipping_account.id), params: { shipping_account: { credentials: { test: 'key' } } }, headers: header
      assert_response :forbidden
    end

    test 'patch members#update with auth scope' do
      member = create(:member, role: :basic, scopes: ['shipping_accounts/write'])
      shipping_account = create(:shipping_account, account: member.account)
      header = valid_headers(member)
      patch shipping_account_url(shipping_account.id), params: { shipping_account: { credentials: { test: 'key' } } }, headers: header
      assert_equal({ 'test' => 'key' }, shipping_account.reload.credentials)
      assert_response :ok
    end

    # Members DESTROY tests

    test 'delete shipping_accounts#destroy' do
      member = create(:member)
      shipping_account = create(:shipping_account, account: member.account)
      header = valid_headers(member)
      assert_difference 'member.account.shipping_accounts.count', -1 do
        delete shipping_account_url(shipping_account.id), headers: header
      end
      assert_response :no_content
    end

    test 'delete shipping_accounts#destroy without auth' do
      shipping_account = create(:shipping_account)
      delete shipping_account_url(shipping_account.id)
      assert_response :unauthorized
    end

    test 'delete shipping_accounts#destroy with expired auth' do
      member = create(:member)
      shipping_account = create(:shipping_account, account: member.account)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      delete shipping_account_url(shipping_account.id), headers: header
      assert_response :unauthorized
    end

    test 'delete shipping_accounts#destroy without auth scope' do
      member = create(:member, role: :basic)
      shipping_account = create(:shipping_account, account: member.account)
      header = valid_headers(member)
      delete shipping_account_url(shipping_account.id), headers: header
      assert_response :forbidden
    end

    test 'delete members#destroy with auth scope' do
      member = create(:member, role: :basic, scopes: ['shipping_accounts/delete'])
      shipping_account = create(:shipping_account, account: member.account)
      header = valid_headers(member)
      assert_difference 'member.account.shipping_accounts.count', -1 do
        delete shipping_account_url(shipping_account.id), headers: header
      end
      assert_response :no_content
    end

    private

    def valid_shipping_account(account)
      shipping_carrier = create(:shipping_carrier)
      shipping_account = ShippingAccount.new(credentials: { key: 'test' }, shipping_carrier_id: shipping_carrier.id)
      { shipping_account: shipping_account.attributes }
    end
  end
end
