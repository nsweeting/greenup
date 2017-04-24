require 'test_helper'
require 'controllers/test_helper'

module V1
  class CountriesControllerTest < ActionDispatch::IntegrationTest
    # Countries INDEX tests

    test 'get countries#index' do
      member = create(:member)
      create(:country)
      header = valid_headers(member)
      get countries_url, headers: header
      assert_response :ok
      assert_serializer 'ActiveModel::Serializer::CollectionSerializer'
    end

    test 'get countries#index without auth' do
      get countries_url
      assert_response :unauthorized
    end

    test 'get countries#index with expired auth' do
      member = create(:member)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      get countries_url, headers: header
      assert_response :unauthorized
    end
  end
end
