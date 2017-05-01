require 'test_helper'
require 'controllers/test_helper'

module V1
  class ZonesControllerTest < ActionDispatch::IntegrationTest
    # Zones CREATE tests

    test 'post zones#create' do
      member = create(:member)
      header = valid_headers(member)
      assert_difference 'member.account.zones.count' do
        post zones_url, params: valid_zone, headers: header
      end
      assert_response :created
      assert_serializer 'V1::ZoneSerializer'
    end

    test 'post zones#create without auth' do
      get zones_url, params: valid_zone
      assert_response :unauthorized
    end

    test 'post zones#create with expired auth' do
      member = create(:member)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      post zones_url, params: valid_zone, headers: header
      assert_response :unauthorized
    end

    test 'post zones#create without auth scope' do
      member = create(:member, role: :basic)
      header = valid_headers(member)
      get zones_url, params: valid_zone, headers: header
      assert_response :forbidden
    end

    test 'post zones#create with auth scope' do
      member = create(:member, role: :basic, scopes: ['zones/write'])
      header = valid_headers(member)
      assert_difference 'member.account.zones.count' do
        post zones_url, params: valid_zone, headers: header
      end
      assert_response :created
      assert_serializer 'V1::ZoneSerializer'
    end

    # Zones INDEX tests

    test 'get zones#index' do
      member = create(:member)
      create_list(:zone, 3, account: member.account)
      header = valid_headers(member)
      get zones_url, headers: header
      assert_response :ok
      assert_serializer 'ActiveModel::Serializer::CollectionSerializer'
    end

    test 'get zones#index without auth' do
      get zones_url
      assert_response :unauthorized
    end

    test 'get zones#index with expired auth' do
      member = create(:member)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      get zones_url, headers: header
      assert_response :unauthorized
    end

    test 'get zones#index without auth scope' do
      member = create(:member, role: :basic)
      create_list(:zone, 3, account: member.account)
      header = valid_headers(member)
      get zones_url, headers: header
      assert_response :forbidden
    end

    test 'get zones#index with auth scope' do
      member = create(:member, role: :basic, scopes: ['zones/read'])
      create_list(:zone, 3, account: member.account)
      header = valid_headers(member)
      get zones_url, headers: header
      assert_response :ok
      assert_serializer 'ActiveModel::Serializer::CollectionSerializer'
    end

    # Zones SHOW tests

    test 'get zone#show' do
      member = create(:member)
      zone = create(:zone, account: member.account)
      header = valid_headers(member)
      get zone_url(zone.id), headers: header
      assert_response :ok
      assert_serializer 'V1::ZoneSerializer'
    end

    test 'get zones#show without auth' do
      zone = create(:zone)
      get zone_url(zone.id)
      assert_response :unauthorized
    end

    test 'get zones#show with expired auth' do
      member = create(:member)
      zone = create(:zone, account: member.account)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      get zone_url(zone.id), headers: header
      assert_response :unauthorized
    end

    test 'get zones#show without auth scope' do
      member = create(:member, role: :basic)
      zone = create(:zone, account: member.account)
      header = valid_headers(member)
      get zone_url(zone.id), headers: header
      assert_response :forbidden
    end

    test 'get zones#show with auth scope' do
      member = create(:member, role: :basic, scopes: ['zones/read'])
      zone = create(:zone, account: member.account)
      header = valid_headers(member)
      get zone_url(zone.id), headers: header
      assert_response :ok
      assert_serializer 'V1::ZoneSerializer'
    end

    # Members UPDATE tests

    test 'patch zones#update' do
      member = create(:member)
      zone = create(:zone, account: member.account)
      header = valid_headers(member)
      patch zone_url(zone.id), params: { zone: { name: 'new' } }, headers: header
      assert_equal 'new', zone.reload.name
      assert_response :ok
    end

    test 'patch zones#update without auth' do
      zone = create(:zone)
      patch zone_url(zone.id), params: { zone: { name: 'new' } }
      assert_response :unauthorized
    end

    test 'patch zones#update with expired auth' do
      member = create(:member)
      zone = create(:zone, account: member.account)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      patch zone_url(zone.id), params: { zone: { name: 'new' } }, headers: header
      assert_response :unauthorized
    end

    test 'patch zones#update without auth scope' do
      member = create(:member, role: :basic)
      zone = create(:zone, account: member.account)
      header = valid_headers(member)
      patch zone_url(zone.id), params: { zone: { name: 'new' } }, headers: header
      assert_response :forbidden
    end

    test 'patch members#update with auth scope' do
      member = create(:member, role: :basic, scopes: ['zones/write'])
      zone = create(:zone, account: member.account)
      header = valid_headers(member)
      patch zone_url(zone.id), params: { zone: { name: 'new' } }, headers: header
      assert_equal 'new', zone.reload.name
      assert_response :ok
    end

    # Members DESTROY tests

    test 'delete zones#destroy' do
      member = create(:member)
      zone = create(:zone, account: member.account)
      header = valid_headers(member)
      assert_difference 'member.account.zones.count', -1 do
        delete zone_url(zone.id), headers: header
      end
      assert_response :no_content
    end

    test 'delete zones#destroy without auth' do
      zone = create(:zone)
      delete zone_url(zone.id)
      assert_response :unauthorized
    end

    test 'delete zones#destroy with expired auth' do
      member = create(:member)
      zone = create(:zone, account: member.account)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      delete zone_url(zone.id), headers: header
      assert_response :unauthorized
    end

    test 'delete zones#destroy without auth scope' do
      member = create(:member, role: :basic)
      zone = create(:zone, account: member.account)
      header = valid_headers(member)
      delete zone_url(zone.id), headers: header
      assert_response :forbidden
    end

    test 'delete members#destroy with auth scope' do
      member = create(:member, role: :basic, scopes: ['zones/delete'])
      zone = create(:zone, account: member.account)
      header = valid_headers(member)
      assert_difference 'member.account.zones.count', -1 do
        delete zone_url(zone.id), headers: header
      end
      assert_response :no_content
    end

    private

    def valid_zone
      country = create(:country)
      countries_attributes = { countries_attributes: [{ id: country.id }] }
      zone = Zone.new(name: 'Ontario')
      { zone: zone.attributes.merge(countries_attributes) }
    end
  end
end
