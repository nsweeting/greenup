require 'test_helper'
require 'controllers/test_helper'

module V1
  class MembersControllerTest < ActionDispatch::IntegrationTest
    # Members CREATE tests

    test 'post members#create' do
      member = create(:member)
      header = valid_headers(member)
      params = { member: { confirmation_email: 'test@test.com' } }
      assert_difference 'member.account.members.count' do
        post members_url, params: params, headers: header
      end
      assert_response :created
      assert_serializer 'V1::MemberSerializer'
    end

    test 'post members#create without auth' do
      params = { member: { confirmation_email: 'test@test.com' } }
      get members_url, params: params
      assert_response :unauthorized
    end

    test 'post members#create with expired auth' do
      member = create(:member)
      params = { member: { confirmation_email: 'test@test.com' } }
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      post members_url, params: params, headers: header
      assert_response :unauthorized
    end

    test 'post members#create without auth scope' do
      member = create(:member, role: :basic)
      header = valid_headers(member)
      params = { member: { confirmation_email: 'test@test.com' } }
      get members_url, params: params, headers: header
      assert_response :forbidden
    end

    test 'post members#create with auth scope' do
      member = create(:member, role: :basic, scopes: ['members/write'])
      header = valid_headers(member)
      params = { member: { confirmation_email: 'test@test.com' } }
      assert_difference 'member.account.members.count' do
        post members_url, params: params, headers: header
      end
      assert_response :created
      assert_serializer 'V1::MemberSerializer'
    end

    # Members INDEX tests

    test 'get members#index' do
      member = create(:member)
      create_list(:member, 3, account: member.account, role: :basic)
      header = valid_headers(member)
      get members_url, headers: header
      assert_response :ok
      assert_serializer 'ActiveModel::Serializer::CollectionSerializer'
    end

    test 'get members#index without auth' do
      get members_url
      assert_response :unauthorized
    end

    test 'get members#index with expired auth' do
      member = create(:member)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      get members_url, headers: header
      assert_response :unauthorized
    end

    test 'get members#index without auth scope' do
      member = create(:member)
      members = create_list(:member, 3, account: member.account, role: :basic)
      header = valid_headers(members.first)
      get members_url, headers: header
      assert_response :forbidden
    end

    test 'get members#index with auth scope' do
      member = create(:member, role: :basic, scopes: ['members/read'])
      members = create_list(:member, 3, account: member.account, role: :basic)
      header = valid_headers(member)
      get members_url, headers: header
      assert_response :ok
      assert_serializer 'ActiveModel::Serializer::CollectionSerializer'
    end

    # Members SHOW tests

    test 'get members#show' do
      member = create(:member)
      member_to_find = create(:member, account: member.account, role: :basic)
      header = valid_headers(member)
      get member_url(member_to_find.id), headers: header
      assert_response :ok
      assert_serializer 'V1::MemberSerializer'
    end

    test 'get members#show without auth' do
      member = create(:member)
      get member_url(member.id)
      assert_response :unauthorized
    end

    test 'get members#show with expired auth' do
      member = create(:member)
      member_to_find = create(:member, account: member.account, role: :basic)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      get member_url(member_to_find.id), headers: header
      assert_response :unauthorized
    end

    test 'get members#show without auth scope' do
      member = create(:member)
      member_to_find = create(:member, account: member.account, role: :basic)
      header = valid_headers(member_to_find)
      get member_url(member_to_find.id), headers: header
      assert_response :forbidden
    end

    test 'get members#show with auth scope' do
      member = create(:member, role: :basic, scopes: ['members/read'])
      member_to_find = create(:member, account: member.account, role: :basic)
      header = valid_headers(member)
      get member_url(member_to_find.id), headers: header
      assert_response :ok
      assert_serializer 'V1::MemberSerializer'
    end

    # Members UPDATE tests

    test 'patch members#update' do
      member = create(:member)
      member_to_find = create(:member, account: member.account, role: :basic)
      header = valid_headers(member)
      patch member_url(member_to_find.id), params: { member: { scopes: ['products/delete'] } }, headers: header
      assert_response :ok
      assert_equal ['products/delete'], member_to_find.reload.scopes
      assert_serializer 'V1::MemberSerializer'
    end

    test 'patch members#update without auth' do
      member = create(:member)
      patch member_url(member.id), params: { member: { scopes: ['products/delete'] } }
      assert_response :unauthorized
    end

    test 'patch members#update with expired auth' do
      member = create(:member)
      member_to_find = create(:member, account: member.account, role: :basic)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      patch member_url(member_to_find.id), params: { member: { scopes: ['products/delete'] } }, headers: header
      assert_response :unauthorized
    end

    test 'patch members#update without auth scope' do
      member = create(:member)
      member_to_find = create(:member, account: member.account, role: :basic)
      header = valid_headers(member_to_find)
      patch member_url(member_to_find.id), params: { member: { scopes: ['products/delete'] } }, headers: header
      assert_response :forbidden
    end

    test 'patch members#update with auth scope' do
      member = create(:member, role: :basic, scopes: ['members/write'])
      member_to_find = create(:member, account: member.account, role: :basic)
      header = valid_headers(member)
      patch member_url(member_to_find.id), params: { member: { scopes: ['products/delete'] } }, headers: header
      assert_response :ok
      assert_equal ['products/delete'], member_to_find.reload.scopes
      assert_serializer 'V1::MemberSerializer'
    end

    # Members DESTROY tests

    test 'delete members#destroy' do
      member = create(:member)
      member_to_find = create(:member, account: member.account, role: :basic)
      header = valid_headers(member)
      assert_difference 'member.account.members.count', -1 do
        delete member_url(member_to_find.id), headers: header
      end
      assert_response :no_content
    end

    test 'delete members#destroy without auth' do
      member = create(:member)
      delete member_url(member.id)
      assert_response :unauthorized
    end

    test 'delete members#destroy with expired auth' do
      member = create(:member)
      member_to_find = create(:member, account: member.account, role: :basic)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      delete member_url(member_to_find.id), headers: header
      assert_response :unauthorized
    end

    test 'delete members#destroy without auth scope' do
      member = create(:member)
      member_to_find = create(:member, account: member.account, role: :basic)
      header = valid_headers(member_to_find)
      delete member_url(member_to_find.id), headers: header
      assert_response :forbidden
    end

    test 'delete members#destroy with auth scope' do
      member = create(:member, role: :basic, scopes: ['members/delete'])
      member_to_find = create(:member, account: member.account, role: :basic)
      header = valid_headers(member)
      assert_difference 'member.account.members.count', -1 do
        delete member_url(member_to_find.id), headers: header
      end
      assert_response :no_content
    end
  end
end
