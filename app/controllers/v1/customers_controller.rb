module V1
  class CustomersController < ApplicationController
    before_action { authorize Customer }
    before_action :set_customer, only: [:show, :update, :destroy]

    def create
      customer = current_account.customers.new(permitted_params)
      if customer.save
        render json: customer, status: :created
      else
        resource_errors(customer.errors)
      end
    end

    def index
      customers = scopes_with_paging(current_account.customers)
      render json: customers, status: :ok
    end

    def show
      render json: @customer, status: :ok
    end

    def update
      if @customer.update_attributes(permitted_params)
        render json: @customer, status: :ok
      else
        resource_errors(@customer.errors)
      end
    end

    def destroy
      @customer.destroy
      render json: {}, status: :no_content
    end

    private

    def set_customer
      @customer = current_account.customers.find(params[:id])
    end

    def permitted_params
      params
        .require(:customer)
        .permit(:email, :first_name, :last_name, :company, :tax_exempt, :phone)
    end
  end
end
