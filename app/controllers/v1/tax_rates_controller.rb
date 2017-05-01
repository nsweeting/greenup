module V1
  class TaxRatesController < ApplicationController
    before_action { authorize TaxRate }
    before_action :set_tax_rate, only: [:show, :update, :destroy]

    def create
      tax_rate = current_account.tax_rates.new(permitted_params)
      if tax_rate.save
        render json: tax_rate, status: :created
      else
        resource_errors(tax_rate.errors)
      end
    end

    def index
      tax_rates = scopes_with_paging(current_account.tax_rates)
      render json: tax_rates, status: :ok
    end

    def show
      render json: @tax_rate, status: :ok
    end

    def update
      if @tax_rate.update_attributes(permitted_params)
        render json: @tax_rate, status: :ok
      else
        resource_errors(@tax_rate.errors)
      end
    end

    def destroy
      @tax_rate.destroy
      render json: {}, status: :no_content
    end

    private

    def set_tax_rate
      @tax_rate = current_account.tax_rates.find(params[:id])
    end

    def permitted_params
      params
        .require(:tax_rate)
        .permit(:name, :amount, :zone_id)
    end
  end
end
