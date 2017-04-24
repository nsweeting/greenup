module V1
  class ErrorsController < ApplicationController
    skip_before_action :authenticate_request

    def catch_404
      raise ActionController::RoutingError, 'Route not found'
    end
  end
end
