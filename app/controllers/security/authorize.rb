module Security
  class Authorize
    class << self
      def call(*args)
        auth = new(*args)
        auth.call
        auth
      end
    end

    attr_reader :member

    def initialize(request)
      @request        = request
      @valid          = false
    end

    def call
      token = decode_token
      return unless token.present?
      member_from(token)
    end

    def valid?
      @valid
    end

    def member_from(token)
      auth = [token[:mid], token[:uid], account_name]
      @member = Member.for_authorization(*auth).first
      valid! if @member.present?
    end

    private

    attr_reader :request, :token

    def decode_token
      body = JWT.decode(auth_header, Rails.application.secrets.secret_key_base)[0]
      HashWithIndifferentAccess.new(body)
    rescue
      nil
    end

    def headers
      request.headers
    end

    def account_name
      request.subdomain
    end

    def auth_header
      return unless headers['Authorization'].present?
      headers['Authorization'].split(' ').last
    end

    def valid!
      @valid = true
    end
  end
end
