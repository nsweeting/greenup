module Constraints
  class ApiVersion
    def initialize(options)
      @version = options[:version]
      @default = options[:default]
    end

    def matches?(req)
      @default || req.headers['Accept'].include?("application/vnd.app-email.v#{@version}")
    end
  end
end
