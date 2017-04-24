module Security
  class Authenticate
    class << self
      def call(*args)
        auth = new(*args)
        auth.call
        auth
      end
    end

    attr_reader :token

    def initialize(options = {})
      @email     = options[:email]
      @password  = options[:password]
      @account   = options[:account]
      @lifetime  = options[:lifetime]
      @token     = nil
      @valid     = false
    end

    def call
      member = Member.for_authentication(email, account).first
      return unless authenticate!(member&.user)
      @token = token_for(member)
    end

    def valid?
      @valid
    end

    def token_for(member)
      payload = payload_for(member)
      JWT.encode(payload, Rails.application.secrets.secret_key_base)
    end

    def authenticate!(user)
      valid! if user && user.authenticate(password)
    end

    private

    attr_reader :email, :password, :account

    def valid!
      @valid = true
    end

    def lifetime
      @lifetime || 30.minutes.from_now.to_i
    end

    def payload_for(member)
      {
        mid: member.id,
        aid: member.account_id,
        uid: member.user_id,
        exp: lifetime
      }
    end
  end
end
