module V1
  class CountriesController < ApplicationController
    def index
      countries = scopes_with_paging(Country.all)
      render json: countries, status: :ok
    end
  end
end
