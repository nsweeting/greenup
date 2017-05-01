module V1
  class ShippingAccountsController < ApplicationController
    before_action { authorize ShippingAccount }
    before_action :set_shipping_account, only: [:show, :update, :destroy]

    def create
      shipping_account = current_account.shipping_accounts.new(permitted_params)
      if shipping_account.save
        render json: shipping_account, status: :created
      else
        resource_errors(shipping_account.errors)
      end
    end

    def index
      shipping_accounts = scopes_with_paging(current_account.shipping_accounts)
      render json: shipping_accounts, status: :ok
    end

    def show
      render json: @shipping_account, status: :ok
    end

    def update
      if @shipping_account.update_attributes(permitted_params)
        render json: @shipping_account, status: :ok
      else
        resource_errors(@shipping_account.errors)
      end
    end

    def destroy
      @shipping_account.destroy
      render json: {}, status: :no_content
    end

    private

    def set_shipping_account
      @shipping_account = current_account.shipping_accounts.find(params[:id])
    end

    def permitted_params
      credential_keys = params[:shipping_account][:credentials].keys
      params
        .require(:shipping_account)
        .permit(:shipping_carrier_id, credentials: credential_keys)
    end
  end
end
