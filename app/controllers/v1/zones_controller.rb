module V1
  class ZonesController < ApplicationController
    before_action { authorize Zone }
    before_action :set_zone, only: [:show, :update, :destroy]

    def create
      zone = current_account.zones.new(permitted_params)
      if zone.save
        render json: zone, status: :created
      else
        resource_errors(zone.errors)
      end
    end

    def index
      zones = scopes_with_paging(current_account.zones)
      render json: zones, status: :ok
    end

    def show
      render json: @zone, status: :ok
    end

    def update
      if @zone.update_attributes(permitted_params)
        render json: @zone, status: :ok
      else
        resource_errors(@zone.errors)
      end
    end

    def destroy
      @zone.destroy
      render json: {}, status: :no_content
    end

    private

    def set_zone
      @zone = current_account.zones.find(params[:id])
    end

    def permitted_params
      params
        .require(:zone)
        .permit(:name, :description, countries_attributes: [:id], provinces_attributes: [:id])
    end
  end
end
