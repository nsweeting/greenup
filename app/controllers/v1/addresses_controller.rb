module V1
  class AddressesController < ApplicationController
    before_action { authorize Address }
    before_action :set_address, only: [:show, :update, :destroy]

    def create
      address = current_customer.addresses.new(permitted_params)
      if address.save
        render json: address, status: :created
      else
        resource_errors(address.errors)
      end
    end

    def index
      addresses = scopes_with_paging(current_customer.addresses)
      render json: addresses, status: :ok
    end

    def show
      render json: @address, status: :ok
    end

    def update
      if @address.update_attributes(permitted_params)
        render json: @address, status: :ok
      else
        resource_errors(@address.errors)
      end
    end

    def destroy
      @address.destroy
      render json: {}, status: :no_content
    end

    private

    def current_customer
      current_account.customers.find(params[:customer_id])
    end

    def set_address
      @address = current_customer.addresses.find(params[:id])
    end

    def permitted_params
      params
        .require(:address)
        .permit(:address_1, :address_2, :city, :company, :first_name, :last_name,
                :phone, :postal_code, :default, :category, :province_id,
                :country_id)
    end
  end
end
