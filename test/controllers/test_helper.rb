class ActiveSupport::TestCase
  include ActiveModelSerializers::Test::Serializer

  def version_header(version = 1)
    { 'ACCEPT' => "application/vnd.app-email.v#{version}" }
  end

  def valid_auth_header(member)
    auth_hash = { account: member.account.name, email: member.user.email, password: 'password' }
    auth = Security::Authenticate.call(auth_hash)
    { 'AUTHORIZATION' => auth.token }
  end

  def valid_headers(member, version = 1)
    host!("#{member.account.name}.example")
    version = version_header(version)
    auth = valid_auth_header(member)
    version.merge!(auth)
  end
end
