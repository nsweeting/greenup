module V1
  class ProvincesController < ApplicationController
    def index
      provinces = scopes_with_paging(Province.all)
      render json: provinces, status: :ok
    end
  end
end
