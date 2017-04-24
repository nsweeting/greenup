require 'test_helper'
require 'controllers/test_helper'

module V1
  class LineItemsControllerTest < ActionDispatch::IntegrationTest
    # LineItems CREATE tests

    test 'post line_items#create' do
      member = create(:member)
      header = valid_headers(member)
      order = create(:order, account: member.account)
      assert_difference 'member.account.line_items.count' do
        post order_line_items_url(order.id), params: valid_line_item(member.account), headers: header
      end
      assert_response :created
      assert_serializer 'V1::LineItemSerializer'
    end

    test 'post line_items#create without auth' do
      order = create(:order)
      get order_line_items_url(order.id), params: valid_line_item(order.account)
      assert_response :unauthorized
    end

    test 'post line_items#create with expired auth' do
      member = create(:member)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      order = create(:order, account: member.account)
      post order_line_items_url(order.id), params: valid_line_item(member.account), headers: header
      assert_response :unauthorized
    end

    test 'post line_items#create without auth scope' do
      member = create(:member, role: :basic)
      header = valid_headers(member)
      order = create(:order, account: member.account)
      get order_line_items_url(order.id), params: valid_line_item(member.account), headers: header
      assert_response :forbidden
    end

    test 'post line_items#create with auth scope' do
      member = create(:member, role: :basic, scopes: ['orders/write'])
      header = valid_headers(member)
      order = create(:order, account: member.account)
      assert_difference 'member.account.line_items.count' do
        post order_line_items_url(order.id), params: valid_line_item(member.account), headers: header
      end
      assert_response :created
      assert_serializer 'V1::LineItemSerializer'
    end

    # LineItems INDEX tests

    test 'get line_items#index' do
      member = create(:member)
      order = create(:order, account: member.account)
      create_list(:line_item, 3, order: order)
      header = valid_headers(member)
      get order_line_items_url(order.id), headers: header
      assert_response :ok
      assert_serializer 'ActiveModel::Serializer::CollectionSerializer'
    end

    test 'get line_items#index without auth' do
      order = create(:order)
      get order_line_items_url(order.id)
      assert_response :unauthorized
    end

    test 'get line_items#index with expired auth' do
      member = create(:member)
      order = create(:order, account: member.account)
      create_list(:line_item, 3, order: order)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      get order_line_items_url(order.id), headers: header
      assert_response :unauthorized
    end

    test 'get line_items#index without auth scope' do
      member = create(:member, role: :basic)
      order = create(:order, account: member.account)
      create_list(:line_item, 3, order: order)
      header = valid_headers(member)
      get order_line_items_url(order.id), headers: header
      assert_response :forbidden
    end

    test 'get line_items#index with auth scope' do
      member = create(:member, role: :basic, scopes: ['orders/read'])
      order = create(:order, account: member.account)
      create_list(:line_item, 3, order: order)
      header = valid_headers(member)
      get order_line_items_url(order.id), headers: header
      assert_response :ok
      assert_serializer 'ActiveModel::Serializer::CollectionSerializer'
    end

    # LineItems SHOW tests

    test 'get line_items#show' do
      member = create(:member)
      order = create(:order, account: member.account)
      line_item = create(:line_item, order: order)
      header = valid_headers(member)
      get order_line_item_url(order.id, line_item.id), headers: header
      assert_response :ok
      assert_serializer 'V1::LineItemSerializer'
    end

    test 'get line_items#show without auth' do
      order = create(:order)
      line_item = create(:line_item, order: order)
      get order_line_item_url(order.id, line_item.id)
      assert_response :unauthorized
    end

    test 'get line_items#show with expired auth' do
      member = create(:member)
      order = create(:order, account: member.account)
      line_item = create(:line_item, order: order)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      get order_line_item_url(order.id, line_item.id), headers: header
      assert_response :unauthorized
    end

    test 'get line_items#show without auth scope' do
      member = create(:member, role: :basic)
      order = create(:order, account: member.account)
      line_item = create(:line_item, order: order)
      header = valid_headers(member)
      get order_line_item_url(order.id, line_item.id), headers: header
      assert_response :forbidden
    end

    test 'get line_items#show with auth scope' do
      member = create(:member, role: :basic, scopes: ['orders/read'])
      order = create(:order, account: member.account)
      line_item = create(:line_item, order: order)
      header = valid_headers(member)
      get order_line_item_url(order.id, line_item.id), headers: header
      assert_response :ok
      assert_serializer 'V1::LineItemSerializer'
    end

    # Members UPDATE tests

    test 'patch line_items#update' do
      member = create(:member)
      order = create(:order, account: member.account)
      line_item = create(:line_item, order: order)
      header = valid_headers(member)
      patch order_line_item_url(order.id, line_item.id), params: { line_item: { requires_shipping: false } }, headers: header
      assert_equal false, line_item.reload.requires_shipping
      assert_response :ok
    end

    test 'patch line_items#update without auth' do
      order = create(:order)
      line_item = create(:line_item, order: order)
      patch order_line_item_url(order.id, line_item.id), params: { line_item: { requires_shipping: false } }
      assert_response :unauthorized
    end

    test 'patch line_items#update with expired auth' do
      member = create(:member)
      order = create(:order, account: member.account)
      line_item = create(:line_item, order: order)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      patch order_line_item_url(order.id, line_item.id), params: { line_item: { requires_shipping: false } }, headers: header
      assert_response :unauthorized
    end

    test 'patch line_items#update without auth scope' do
      member = create(:member, role: :basic)
      order = create(:order, account: member.account)
      line_item = create(:line_item, order: order)
      header = valid_headers(member)
      patch order_line_item_url(order.id, line_item.id), params: { line_item: { requires_shipping: false } }, headers: header
      assert_response :forbidden
    end

    test 'patch line_items#update with auth scope' do
      member = create(:member, role: :basic, scopes: ['orders/write'])
      order = create(:order, account: member.account)
      line_item = create(:line_item, order: order)
      header = valid_headers(member)
      patch order_line_item_url(order.id, line_item.id), params: { line_item: { requires_shipping: false } }, headers: header
      assert_equal false, line_item.reload.requires_shipping
      assert_response :ok
    end

    # Members DESTROY tests

    test 'delete line_items#destroy' do
      member = create(:member)
      order = create(:order, account: member.account)
      line_item = create(:line_item, order: order)
      header = valid_headers(member)
      assert_difference 'member.account.line_items.count', -1 do
        delete order_line_item_url(order.id, line_item.id), headers: header
      end
      assert_response :no_content
    end

    test 'delete line_items#destroy without auth' do
      order = create(:order)
      line_item = create(:line_item, order: order)
      delete order_line_item_url(order.id, line_item.id)
      assert_response :unauthorized
    end

    test 'delete line_items#destroy with expired auth' do
      member = create(:member)
      order = create(:order, account: member.account)
      line_item = create(:line_item, order: order)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      delete order_line_item_url(order.id, line_item.id), headers: header
      assert_response :unauthorized
    end

    test 'delete line_items#destroy without auth scope' do
      member = create(:member, role: :basic)
      order = create(:order, account: member.account)
      line_item = create(:line_item, order: order)
      header = valid_headers(member)
      delete order_line_item_url(order.id, line_item.id), headers: header
      assert_response :forbidden
    end

    test 'delete members#destroy with auth scope' do
      member = create(:member, role: :basic, scopes: ['orders/delete'])
      order = create(:order, account: member.account)
      line_item = create(:line_item, order: order)
      header = valid_headers(member)
      assert_difference 'member.account.line_items.count', -1 do
        delete order_line_item_url(order.id, line_item.id), headers: header
      end
      assert_response :no_content
    end

    private

    def valid_line_item(account)
      product = create(:product, account: account)
      variant = create(:variant, product: product)
      line_item = LineItem.new(variant_id: variant.id)
      { line_item: line_item.attributes }
    end
  end
end
