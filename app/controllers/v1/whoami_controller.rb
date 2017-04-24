module V1
  class WhoamiController < ApplicationController
    def show
      render json: current_member, status: :ok
    end
  end
end
