require 'test_helper'
require 'controllers/test_helper'

module V1
  class VariantsControllerTest < ActionDispatch::IntegrationTest
    # Variants CREATE tests

    test 'post variants#create' do
      member = create(:member)
      product = create(:product, account: member.account)
      header = valid_headers(member)
      assert_difference 'product.variants.count' do
        post product_variants_url(product.id), params: valid_variant, headers: header
      end
      assert_response :created
      assert_serializer 'V1::VariantSerializer'
    end

    test 'post variants#create without auth' do
      product = create(:product)
      get product_variants_url(product.id), params: valid_variant
      assert_response :unauthorized
    end

    test 'post variants#create with expired auth' do
      member = create(:member)
      product = create(:product, account: member.account)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      post product_variants_url(product.id), params: valid_variant, headers: header
      assert_response :unauthorized
    end

    test 'post variants#create without auth scope' do
      member = create(:member, role: :basic)
      product = create(:product, account: member.account)
      header = valid_headers(member)
      get product_variants_url(product.id), params: valid_variant, headers: header
      assert_response :forbidden
    end

    test 'post variants#create with auth scope' do
      member = create(:member, role: :basic, scopes: ['variants/write'])
      product = create(:product, account: member.account)
      header = valid_headers(member)
      assert_difference 'member.account.variants.count' do
        post product_variants_url(product.id), params: valid_variant, headers: header
      end
      assert_response :created
      assert_serializer 'V1::VariantSerializer'
    end

    # Variants INDEX tests

    test 'get variants#index' do
      member = create(:member)
      product = create(:product, account: member.account)
      create_list(:variant, 3, product: product)
      header = valid_headers(member)
      get product_variants_url(product.id), headers: header
      assert_response :ok
      assert_serializer 'ActiveModel::Serializer::CollectionSerializer'
    end

    test 'get variants#index without auth' do
      product = create(:product)
      get product_variants_url(product.id)
      assert_response :unauthorized
    end

    test 'get variants#index with expired auth' do
      member = create(:member)
      product = create(:product, account: member.account)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      get product_variants_url(product.id), headers: header
      assert_response :unauthorized
    end

    test 'get variants#index without auth scope' do
      member = create(:member, role: :basic)
      product = create(:product, account: member.account)
      create_list(:variant, 3, product: product)
      header = valid_headers(member)
      get product_variants_url(product.id), headers: header
      assert_response :forbidden
    end

    test 'get variants#index with auth scope' do
      member = create(:member, role: :basic, scopes: ['variants/read'])
      product = create(:product, account: member.account)
      create_list(:variant, 3, product: product)
      header = valid_headers(member)
      get product_variants_url(product.id), headers: header
      assert_response :ok
      assert_serializer 'ActiveModel::Serializer::CollectionSerializer'
    end

    # Variants SHOW tests

    test 'get variant#show' do
      member = create(:member)
      product = create(:product, account: member.account)
      variant = create(:variant, product: product)
      header = valid_headers(member)
      get product_variant_url(product.id, variant.id), headers: header
      assert_response :ok
      assert_serializer 'V1::VariantSerializer'
    end

    test 'get variants#show without auth' do
      product = create(:product)
      variant = create(:variant, product: product)
      get product_variant_url(product.id, variant.id)
      assert_response :unauthorized
    end

    test 'get variants#show with expired auth' do
      member = create(:member)
      product = create(:product, account: member.account)
      variant = create(:variant, product: product)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      get product_variant_url(product.id, variant.id), headers: header
      assert_response :unauthorized
    end

    test 'get variants#show without auth scope' do
      member = create(:member, role: :basic)
      product = create(:product, account: member.account)
      variant = create(:variant, product: product)
      header = valid_headers(member)
      get product_variant_url(product.id, variant.id), headers: header
      assert_response :forbidden
    end

    test 'get variants#show with auth scope' do
      member = create(:member, role: :basic, scopes: ['variants/read'])
      product = create(:product, account: member.account)
      variant = create(:variant, product: product)
      header = valid_headers(member)
      get product_variant_url(product.id, variant.id), headers: header
      assert_response :ok
      assert_serializer 'V1::VariantSerializer'
    end

    # Variants UPDATE tests

    test 'patch variants#update' do
      member = create(:member)
      product = create(:product, account: member.account)
      variant = create(:variant, product: product)
      header = valid_headers(member)
      patch product_variant_url(product.id, variant.id), params: { variant: { title: 'new' } }, headers: header
      assert_equal 'new', variant.reload.title
      assert_response :ok
    end

    test 'patch variants#update without auth' do
      product = create(:product)
      variant = create(:variant, product: product)
      patch product_variant_url(product.id, variant.id), params: { variant: { title: 'new' } }
      assert_response :unauthorized
    end

    test 'patch variants#update with expired auth' do
      member = create(:member)
      product = create(:product, account: member.account)
      variant = create(:variant, product: product)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      patch product_variant_url(product.id, variant.id), params: { variant: { title: 'new' } }, headers: header
      assert_response :unauthorized
    end

    test 'patch variants#update without auth scope' do
      member = create(:member, role: :basic)
      product = create(:product, account: member.account)
      variant = create(:variant, product: product)
      header = valid_headers(member)
      patch product_variant_url(product.id, variant.id), params: { variant: { title: 'new' } }, headers: header
      assert_response :forbidden
    end

    test 'patch members#update with auth scope' do
      member = create(:member, role: :basic, scopes: ['variants/write'])
      product = create(:product, account: member.account)
      variant = create(:variant, product: product)
      header = valid_headers(member)
      patch product_variant_url(product.id, variant.id), params: { variant: { title: 'new' } }, headers: header
      assert_equal 'new', variant.reload.title
      assert_response :ok
    end

    # Variants DESTROY tests

    test 'delete variants#destroy' do
      member = create(:member)
      product = create(:product, account: member.account)
      variant = create(:variant, product: product)
      header = valid_headers(member)
      assert_difference 'product.variants.count', -1 do
        delete product_variant_url(product.id, variant.id), headers: header
      end
      assert_response :no_content
    end

    test 'delete variants#destroy without auth' do
      product = create(:product)
      variant = create(:variant, product: product)
      delete product_variant_url(product.id, variant.id)
      assert_response :unauthorized
    end

    test 'delete variants#destroy with expired auth' do
      member = create(:member)
      product = create(:product, account: member.account)
      variant = create(:variant, product: product)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      delete product_variant_url(product.id, variant.id), headers: header
      assert_response :unauthorized
    end

    test 'delete variants#destroy without auth scope' do
      member = create(:member, role: :basic)
      product = create(:product, account: member.account)
      variant = create(:variant, product: product)
      header = valid_headers(member)
      delete product_variant_url(product.id, variant.id), headers: header
      assert_response :forbidden
    end

    test 'delete members#destroy with auth scope' do
      member = create(:member, role: :basic, scopes: ['variants/delete'])
      product = create(:product, account: member.account)
      variant = create(:variant, product: product)
      header = valid_headers(member)
      assert_difference 'product.variants.count', -1 do
        delete product_variant_url(product.id, variant.id), headers: header
      end
      assert_response :no_content
    end

    private

    def valid_variant
      variant = Variant.new(title: 'test')
      { variant: variant.attributes }
    end
  end
end
