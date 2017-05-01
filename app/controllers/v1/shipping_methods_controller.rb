module V1
  class ShippingMethodsController < ApplicationController
    before_action { authorize ShippingMethod }
    before_action :set_shipping_method, only: [:show, :update, :destroy]

    def create
      shipping_method = current_account.shipping_methods.new(permitted_params)
      if shipping_method.save
        render json: shipping_method, status: :created
      else
        resource_errors(shipping_method.errors)
      end
    end

    def index
      shipping_methods = scopes_with_paging(current_account.shipping_methods)
      render json: shipping_methods, status: :ok
    end

    def show
      render json: @shipping_method, status: :ok
    end

    def update
      if @shipping_method.update_attributes(permitted_params)
        render json: @shipping_method, status: :ok
      else
        resource_errors(@shipping_method.errors)
      end
    end

    def destroy
      @shipping_method.destroy
      render json: {}, status: :no_content
    end

    private

    def set_shipping_method
      @shipping_method = current_account.shipping_methods.find(params[:id])
    end

    def permitted_params
      params
        .require(:shipping_method)
        .permit(:name, :zone_id, :shipping_service_id)
    end
  end
end
