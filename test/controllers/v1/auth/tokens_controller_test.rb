require 'test_helper'
require 'controllers/test_helper'

module V1
  module Auth
    class TokensControllerTest < ActionDispatch::IntegrationTest
      test 'can create a token' do
        member = create(:member)
        params = { auth: { account: member.account.name, email: member.user.email, password: 'password' } }
        post auth_tokens_url, params: params, headers: version_header
        assert_response :created
        body = JSON.parse(response.body)
        assert body['token'].present?
      end

      test 'cannot create a token with invalid credentials' do
        member = create(:member)
        params = { auth: { account: member.account.name, email: member.user.email, password: 'badpassword' } }
        post auth_tokens_url, params: params, headers: version_header
        assert_response :unauthorized
      end

      test 'cannot create a token with a bad user/account relation' do
        member = create(:member)
        account = create(:account)
        params = { auth: { account: account.name, email: member.user.email, password: 'password' } }
        post auth_tokens_url, params: params, headers: version_header
        assert_response :unauthorized
      end
    end
  end
end
