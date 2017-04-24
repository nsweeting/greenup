require 'test_helper'
require 'controllers/test_helper'

module V1
  class ProvincesControllerTest < ActionDispatch::IntegrationTest
    # Provinces INDEX tests

    test 'get provinces#index' do
      member = create(:member)
      create(:province)
      header = valid_headers(member)
      get provinces_url, headers: header
      assert_response :ok
      assert_serializer 'ActiveModel::Serializer::CollectionSerializer'
    end

    test 'get provinces#index without auth' do
      get provinces_url
      assert_response :unauthorized
    end

    test 'get provinces#index with expired auth' do
      member = create(:member)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      get provinces_url, headers: header
      assert_response :unauthorized
    end
  end
end
