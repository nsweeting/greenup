require 'test_helper'
require 'controllers/test_helper'

module V1
  class TaxRatesControllerTest < ActionDispatch::IntegrationTest
    # TaxRates CREATE tests

    test 'post tax_rates#create' do
      member = create(:member)
      header = valid_headers(member)
      assert_difference 'member.account.tax_rates.count' do
        post tax_rates_url, params: valid_tax_rate(member.account), headers: header
      end
      assert_response :created
      assert_serializer 'V1::TaxRateSerializer'
    end

    test 'post tax_rates#create without auth' do
      member = create(:member)
      get tax_rates_url, params: valid_tax_rate(member.account)
      assert_response :unauthorized
    end

    test 'post tax_rates#create with expired auth' do
      member = create(:member)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      post tax_rates_url, params: valid_tax_rate(member.account), headers: header
      assert_response :unauthorized
    end

    test 'post tax_rates#create without auth scope' do
      member = create(:member, role: :basic)
      header = valid_headers(member)
      get tax_rates_url, params: valid_tax_rate(member.account), headers: header
      assert_response :forbidden
    end

    test 'post tax_rates#create with auth scope' do
      member = create(:member, role: :basic, scopes: ['tax_rates/write'])
      header = valid_headers(member)
      assert_difference 'member.account.tax_rates.count' do
        post tax_rates_url, params: valid_tax_rate(member.account), headers: header
      end
      assert_response :created
      assert_serializer 'V1::TaxRateSerializer'
    end

    # TaxRates INDEX tests

    test 'get tax_rates#index' do
      member = create(:member)
      create_list(:tax_rate, 3, account: member.account)
      header = valid_headers(member)
      get tax_rates_url, headers: header
      assert_response :ok
      assert_serializer 'ActiveModel::Serializer::CollectionSerializer'
    end

    test 'get tax_rates#index without auth' do
      get tax_rates_url
      assert_response :unauthorized
    end

    test 'get tax_rates#index with expired auth' do
      member = create(:member)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      get tax_rates_url, headers: header
      assert_response :unauthorized
    end

    test 'get tax_rates#index without auth scope' do
      member = create(:member, role: :basic)
      create_list(:tax_rate, 3, account: member.account)
      header = valid_headers(member)
      get tax_rates_url, headers: header
      assert_response :forbidden
    end

    test 'get tax_rates#index with auth scope' do
      member = create(:member, role: :basic, scopes: ['tax_rates/read'])
      create_list(:tax_rate, 3, account: member.account)
      header = valid_headers(member)
      get tax_rates_url, headers: header
      assert_response :ok
      assert_serializer 'ActiveModel::Serializer::CollectionSerializer'
    end

    # TaxRates SHOW tests

    test 'get tax_rate#show' do
      member = create(:member)
      tax_rate = create(:tax_rate, account: member.account)
      header = valid_headers(member)
      get tax_rate_url(tax_rate.id), headers: header
      assert_response :ok
      assert_serializer 'V1::TaxRateSerializer'
    end

    test 'get tax_rates#show without auth' do
      tax_rate = create(:tax_rate)
      get tax_rate_url(tax_rate.id)
      assert_response :unauthorized
    end

    test 'get tax_rates#show with expired auth' do
      member = create(:member)
      tax_rate = create(:tax_rate, account: member.account)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      get tax_rate_url(tax_rate.id), headers: header
      assert_response :unauthorized
    end

    test 'get tax_rates#show without auth scope' do
      member = create(:member, role: :basic)
      tax_rate = create(:tax_rate, account: member.account)
      header = valid_headers(member)
      get tax_rate_url(tax_rate.id), headers: header
      assert_response :forbidden
    end

    test 'get tax_rates#show with auth scope' do
      member = create(:member, role: :basic, scopes: ['tax_rates/read'])
      tax_rate = create(:tax_rate, account: member.account)
      header = valid_headers(member)
      get tax_rate_url(tax_rate.id), headers: header
      assert_response :ok
      assert_serializer 'V1::TaxRateSerializer'
    end

    # Members UPDATE tests

    test 'patch tax_rates#update' do
      member = create(:member)
      tax_rate = create(:tax_rate, account: member.account)
      header = valid_headers(member)
      patch tax_rate_url(tax_rate.id), params: { tax_rate: { name: 'new' } }, headers: header
      assert_equal 'new', tax_rate.reload.name
      assert_response :ok
    end

    test 'patch tax_rates#update without auth' do
      tax_rate = create(:tax_rate)
      patch tax_rate_url(tax_rate.id), params: { tax_rate: { name: 'new' } }
      assert_response :unauthorized
    end

    test 'patch tax_rates#update with expired auth' do
      member = create(:member)
      tax_rate = create(:tax_rate, account: member.account)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      patch tax_rate_url(tax_rate.id), params: { tax_rate: { name: 'new' } }, headers: header
      assert_response :unauthorized
    end

    test 'patch tax_rates#update without auth scope' do
      member = create(:member, role: :basic)
      tax_rate = create(:tax_rate, account: member.account)
      header = valid_headers(member)
      patch tax_rate_url(tax_rate.id), params: { tax_rate: { name: 'new' } }, headers: header
      assert_response :forbidden
    end

    test 'patch members#update with auth scope' do
      member = create(:member, role: :basic, scopes: ['tax_rates/write'])
      tax_rate = create(:tax_rate, account: member.account)
      header = valid_headers(member)
      patch tax_rate_url(tax_rate.id), params: { tax_rate: { name: 'new' } }, headers: header
      assert_equal 'new', tax_rate.reload.name
      assert_response :ok
    end

    # Members DESTROY tests

    test 'delete tax_rates#destroy' do
      member = create(:member)
      tax_rate = create(:tax_rate, account: member.account)
      header = valid_headers(member)
      assert_difference 'member.account.tax_rates.count', -1 do
        delete tax_rate_url(tax_rate.id), headers: header
      end
      assert_response :no_content
    end

    test 'delete tax_rates#destroy without auth' do
      tax_rate = create(:tax_rate)
      delete tax_rate_url(tax_rate.id)
      assert_response :unauthorized
    end

    test 'delete tax_rates#destroy with expired auth' do
      member = create(:member)
      tax_rate = create(:tax_rate, account: member.account)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      delete tax_rate_url(tax_rate.id), headers: header
      assert_response :unauthorized
    end

    test 'delete tax_rates#destroy without auth scope' do
      member = create(:member, role: :basic)
      tax_rate = create(:tax_rate, account: member.account)
      header = valid_headers(member)
      delete tax_rate_url(tax_rate.id), headers: header
      assert_response :forbidden
    end

    test 'delete members#destroy with auth scope' do
      member = create(:member, role: :basic, scopes: ['tax_rates/delete'])
      tax_rate = create(:tax_rate, account: member.account)
      header = valid_headers(member)
      assert_difference 'member.account.tax_rates.count', -1 do
        delete tax_rate_url(tax_rate.id), headers: header
      end
      assert_response :no_content
    end

    private

    def valid_tax_rate(account)
      zone = create(:zone, account: account)
      tax_rate = TaxRate.new(name: 'HST', amount: 0.13, zone_id: zone.id)
      { tax_rate: tax_rate.attributes }
    end
  end
end
