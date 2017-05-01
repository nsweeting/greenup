module V1
  class ShippingCarriersController < ApplicationController
    def index
      shipping_carriers = scopes_with_paging(ShippingCarrier.all)
      render json: shipping_carriers, status: :ok
    end
  end
end
