module V1
  module Auth
    class TokensController < ApplicationController
      skip_before_action :authenticate_request

      def create
        auth = Security::Authenticate.call(permitted_params)
        if auth.valid?
          render json: { token: auth.token }, status: :created
        else
          not_authorized
        end
      end

      private

      def permitted_params
        params
          .require(:auth)
          .permit(:account, :email, :password, :lifetime)
      end
    end
  end
end
