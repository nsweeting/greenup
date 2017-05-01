module V1
  class ShippingServicesController < ApplicationController
    before_action :set_shipping_carrier

    def index
      shipping_services = scopes_with_paging(@shipping_carrier.services)
      render json: shipping_services, status: :ok
    end

    private

    def set_shipping_carrier
      @shipping_carrier = ShippingCarrier.find(params[:shipping_carrier_id])
    end
  end
end
