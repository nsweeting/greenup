require 'test_helper'
require 'controllers/test_helper'

module V1
  class ProductsControllerTest < ActionDispatch::IntegrationTest
    # Products CREATE tests

    test 'post products#create' do
      member = create(:member)
      header = valid_headers(member)
      assert_difference 'member.account.products.count' do
        post products_url, params: valid_product, headers: header
      end
      assert_response :created
      assert_serializer 'V1::ProductSerializer'
    end

    test 'post products#create without auth' do
      get products_url, params: valid_product
      assert_response :unauthorized
    end

    test 'post products#create with expired auth' do
      member = create(:member)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      post products_url, params: valid_product, headers: header
      assert_response :unauthorized
    end

    test 'post products#create without auth scope' do
      member = create(:member, role: :basic)
      header = valid_headers(member)
      get products_url, params: valid_product, headers: header
      assert_response :forbidden
    end

    test 'post products#create with auth scope' do
      member = create(:member, role: :basic, scopes: ['products/write'])
      header = valid_headers(member)
      assert_difference 'member.account.products.count' do
        post products_url, params: valid_product, headers: header
      end
      assert_response :created
      assert_serializer 'V1::ProductSerializer'
    end

    # Products INDEX tests

    test 'get products#index' do
      member = create(:member)
      create_list(:product, 3, account: member.account)
      header = valid_headers(member)
      get products_url, headers: header
      assert_response :ok
      assert_serializer 'ActiveModel::Serializer::CollectionSerializer'
    end

    test 'get products#index without auth' do
      get products_url
      assert_response :unauthorized
    end

    test 'get products#index with expired auth' do
      member = create(:member)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      get products_url, headers: header
      assert_response :unauthorized
    end

    test 'get products#index without auth scope' do
      member = create(:member, role: :basic)
      create_list(:product, 3, account: member.account)
      header = valid_headers(member)
      get products_url, headers: header
      assert_response :forbidden
    end

    test 'get products#index with auth scope' do
      member = create(:member, role: :basic, scopes: ['products/read'])
      create_list(:product, 3, account: member.account)
      header = valid_headers(member)
      get products_url, headers: header
      assert_response :ok
      assert_serializer 'ActiveModel::Serializer::CollectionSerializer'
    end

    # Products SHOW tests

    test 'get product#show' do
      member = create(:member)
      product = create(:product, account: member.account)
      header = valid_headers(member)
      get product_url(product.id), headers: header
      assert_response :ok
      assert_serializer 'V1::ProductSerializer'
    end

    test 'get products#show without auth' do
      product = create(:product)
      get product_url(product.id)
      assert_response :unauthorized
    end

    test 'get products#show with expired auth' do
      member = create(:member)
      product = create(:product, account: member.account)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      get product_url(product.id), headers: header
      assert_response :unauthorized
    end

    test 'get products#show without auth scope' do
      member = create(:member, role: :basic)
      product = create(:product, account: member.account)
      header = valid_headers(member)
      get product_url(product.id), headers: header
      assert_response :forbidden
    end

    test 'get products#show with auth scope' do
      member = create(:member, role: :basic, scopes: ['products/read'])
      product = create(:product, account: member.account)
      header = valid_headers(member)
      get product_url(product.id), headers: header
      assert_response :ok
      assert_serializer 'V1::ProductSerializer'
    end

    # Members UPDATE tests

    test 'patch products#update' do
      member = create(:member)
      product = create(:product, account: member.account)
      header = valid_headers(member)
      patch product_url(product.id), params: { product: { title: 'new' } }, headers: header
      assert_equal 'new', product.reload.title
      assert_response :ok
    end

    test 'patch products#update without auth' do
      product = create(:product)
      patch product_url(product.id), params: { product: { title: 'new' } }
      assert_response :unauthorized
    end

    test 'patch products#update with expired auth' do
      member = create(:member)
      product = create(:product, account: member.account)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      patch product_url(product.id), params: { product: { title: 'new' } }, headers: header
      assert_response :unauthorized
    end

    test 'patch products#update without auth scope' do
      member = create(:member, role: :basic)
      product = create(:product, account: member.account)
      header = valid_headers(member)
      patch product_url(product.id), params: { product: { title: 'new' } }, headers: header
      assert_response :forbidden
    end

    test 'patch members#update with auth scope' do
      member = create(:member, role: :basic, scopes: ['products/write'])
      product = create(:product, account: member.account)
      header = valid_headers(member)
      patch product_url(product.id), params: { product: { title: 'new' } }, headers: header
      assert_equal 'new', product.reload.title
      assert_response :ok
    end

    # Members DESTROY tests

    test 'delete products#destroy' do
      member = create(:member)
      product = create(:product, account: member.account)
      header = valid_headers(member)
      assert_difference 'member.account.products.count', -1 do
        delete product_url(product.id), headers: header
      end
      assert_response :no_content
    end

    test 'delete products#destroy without auth' do
      product = create(:product)
      delete product_url(product.id)
      assert_response :unauthorized
    end

    test 'delete products#destroy with expired auth' do
      member = create(:member)
      product = create(:product, account: member.account)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      delete product_url(product.id), headers: header
      assert_response :unauthorized
    end

    test 'delete products#destroy without auth scope' do
      member = create(:member, role: :basic)
      product = create(:product, account: member.account)
      header = valid_headers(member)
      delete product_url(product.id), headers: header
      assert_response :forbidden
    end

    test 'delete members#destroy with auth scope' do
      member = create(:member, role: :basic, scopes: ['products/delete'])
      product = create(:product, account: member.account)
      header = valid_headers(member)
      assert_difference 'member.account.products.count', -1 do
        delete product_url(product.id), headers: header
      end
      assert_response :no_content
    end

    private

    def valid_product
      product = Product.new(title: 'test')
      { product: product.attributes }
    end
  end
end
