require 'test_helper'
require 'controllers/test_helper'

module V1
  class SaleTaxesControllerTest < ActionDispatch::IntegrationTest
    # SaleTaxes CREATE tests

    test 'post sale_taxes#create' do
      member = create(:member)
      header = valid_headers(member)
      assert_difference 'member.account.sale_taxes.count' do
        post sale_taxes_url, params: valid_sale_tax, headers: header
      end
      assert_response :created
      assert_serializer 'V1::SaleTaxSerializer'
    end

    test 'post sale_taxes#create without auth' do
      get sale_taxes_url, params: valid_sale_tax
      assert_response :unauthorized
    end

    test 'post sale_taxes#create with expired auth' do
      member = create(:member)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      post sale_taxes_url, params: valid_sale_tax, headers: header
      assert_response :unauthorized
    end

    test 'post sale_taxes#create without auth scope' do
      member = create(:member, role: :basic)
      header = valid_headers(member)
      get sale_taxes_url, params: valid_sale_tax, headers: header
      assert_response :forbidden
    end

    test 'post sale_taxes#create with auth scope' do
      member = create(:member, role: :basic, scopes: ['sale_taxes/write'])
      header = valid_headers(member)
      assert_difference 'member.account.sale_taxes.count' do
        post sale_taxes_url, params: valid_sale_tax, headers: header
      end
      assert_response :created
      assert_serializer 'V1::SaleTaxSerializer'
    end

    # SaleTaxes INDEX tests

    test 'get sale_taxes#index' do
      member = create(:member)
      create_list(:sale_tax, 3, account: member.account)
      header = valid_headers(member)
      get sale_taxes_url, headers: header
      assert_response :ok
      assert_serializer 'ActiveModel::Serializer::CollectionSerializer'
    end

    test 'get sale_taxes#index without auth' do
      get sale_taxes_url
      assert_response :unauthorized
    end

    test 'get sale_taxes#index with expired auth' do
      member = create(:member)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      get sale_taxes_url, headers: header
      assert_response :unauthorized
    end

    test 'get sale_taxes#index without auth scope' do
      member = create(:member, role: :basic)
      create_list(:sale_tax, 3, account: member.account)
      header = valid_headers(member)
      get sale_taxes_url, headers: header
      assert_response :forbidden
    end

    test 'get sale_taxes#index with auth scope' do
      member = create(:member, role: :basic, scopes: ['sale_taxes/read'])
      create_list(:sale_tax, 3, account: member.account)
      header = valid_headers(member)
      get sale_taxes_url, headers: header
      assert_response :ok
      assert_serializer 'ActiveModel::Serializer::CollectionSerializer'
    end

    # SaleTaxes SHOW tests

    test 'get sale_tax#show' do
      member = create(:member)
      sale_tax = create(:sale_tax, account: member.account)
      header = valid_headers(member)
      get sale_tax_url(sale_tax.id), headers: header
      assert_response :ok
      assert_serializer 'V1::SaleTaxSerializer'
    end

    test 'get sale_taxes#show without auth' do
      sale_tax = create(:sale_tax)
      get sale_tax_url(sale_tax.id)
      assert_response :unauthorized
    end

    test 'get sale_taxes#show with expired auth' do
      member = create(:member)
      sale_tax = create(:sale_tax, account: member.account)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      get sale_tax_url(sale_tax.id), headers: header
      assert_response :unauthorized
    end

    test 'get sale_taxes#show without auth scope' do
      member = create(:member, role: :basic)
      sale_tax = create(:sale_tax, account: member.account)
      header = valid_headers(member)
      get sale_tax_url(sale_tax.id), headers: header
      assert_response :forbidden
    end

    test 'get sale_taxes#show with auth scope' do
      member = create(:member, role: :basic, scopes: ['sale_taxes/read'])
      sale_tax = create(:sale_tax, account: member.account)
      header = valid_headers(member)
      get sale_tax_url(sale_tax.id), headers: header
      assert_response :ok
      assert_serializer 'V1::SaleTaxSerializer'
    end

    # Members UPDATE tests

    test 'patch sale_taxes#update' do
      member = create(:member)
      sale_tax = create(:sale_tax, account: member.account)
      header = valid_headers(member)
      patch sale_tax_url(sale_tax.id), params: { sale_tax: { name: 'new' } }, headers: header
      assert_equal 'new', sale_tax.reload.name
      assert_response :ok
    end

    test 'patch sale_taxes#update without auth' do
      sale_tax = create(:sale_tax)
      patch sale_tax_url(sale_tax.id), params: { sale_tax: { name: 'new' } }
      assert_response :unauthorized
    end

    test 'patch sale_taxes#update with expired auth' do
      member = create(:member)
      sale_tax = create(:sale_tax, account: member.account)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      patch sale_tax_url(sale_tax.id), params: { sale_tax: { name: 'new' } }, headers: header
      assert_response :unauthorized
    end

    test 'patch sale_taxes#update without auth scope' do
      member = create(:member, role: :basic)
      sale_tax = create(:sale_tax, account: member.account)
      header = valid_headers(member)
      patch sale_tax_url(sale_tax.id), params: { sale_tax: { name: 'new' } }, headers: header
      assert_response :forbidden
    end

    test 'patch members#update with auth scope' do
      member = create(:member, role: :basic, scopes: ['sale_taxes/write'])
      sale_tax = create(:sale_tax, account: member.account)
      header = valid_headers(member)
      patch sale_tax_url(sale_tax.id), params: { sale_tax: { name: 'new' } }, headers: header
      assert_equal 'new', sale_tax.reload.name
      assert_response :ok
    end

    # Members DESTROY tests

    test 'delete sale_taxes#destroy' do
      member = create(:member)
      sale_tax = create(:sale_tax, account: member.account)
      header = valid_headers(member)
      assert_difference 'member.account.sale_taxes.count', -1 do
        delete sale_tax_url(sale_tax.id), headers: header
      end
      assert_response :no_content
    end

    test 'delete sale_taxes#destroy without auth' do
      sale_tax = create(:sale_tax)
      delete sale_tax_url(sale_tax.id)
      assert_response :unauthorized
    end

    test 'delete sale_taxes#destroy with expired auth' do
      member = create(:member)
      sale_tax = create(:sale_tax, account: member.account)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      delete sale_tax_url(sale_tax.id), headers: header
      assert_response :unauthorized
    end

    test 'delete sale_taxes#destroy without auth scope' do
      member = create(:member, role: :basic)
      sale_tax = create(:sale_tax, account: member.account)
      header = valid_headers(member)
      delete sale_tax_url(sale_tax.id), headers: header
      assert_response :forbidden
    end

    test 'delete members#destroy with auth scope' do
      member = create(:member, role: :basic, scopes: ['sale_taxes/delete'])
      sale_tax = create(:sale_tax, account: member.account)
      header = valid_headers(member)
      assert_difference 'member.account.sale_taxes.count', -1 do
        delete sale_tax_url(sale_tax.id), headers: header
      end
      assert_response :no_content
    end

    private

    def valid_sale_tax
      sale_tax = SaleTax.new(name: 'HST', percent: 13)
      { sale_tax: sale_tax.attributes }
    end
  end
end
