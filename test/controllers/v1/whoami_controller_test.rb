require 'test_helper'
require 'controllers/test_helper'

module V1
  class WhoamiControllerTest < ActionDispatch::IntegrationTest
    test 'get whoami#show' do
      member = create(:member)
      header = valid_headers(member)
      get whoami_url, headers: header
      assert_response :ok
      assert_serializer 'V1::MemberSerializer'
    end

    test 'get whoami#show without auth' do
      get whoami_url
      assert_response :unauthorized
    end

    test 'get whoami#show with expired auth' do
      member = create(:member)
      header = Timecop.freeze(Time.now - 30.days) { valid_headers(member) }
      get whoami_url, headers: header
      assert_response :unauthorized
    end
  end
end
