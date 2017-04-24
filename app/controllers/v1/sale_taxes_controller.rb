module V1
  class SaleTaxesController < ApplicationController
    before_action { authorize SaleTax }
    before_action :set_sale_tax, only: [:show, :update, :destroy]

    def create
      sale_tax = current_account.sale_taxes.new(permitted_params)
      if sale_tax.save
        render json: sale_tax, status: :created
      else
        resource_errors(sale_tax.errors)
      end
    end

    def index
      sale_taxes = scopes_with_paging(current_account.sale_taxes)
      render json: sale_taxes, status: :ok
    end

    def show
      render json: @sale_tax, status: :ok
    end

    def update
      if @sale_tax.update_attributes(permitted_params)
        render json: @sale_tax, status: :ok
      else
        resource_errors(@sale_tax.errors)
      end
    end

    def destroy
      @sale_tax.destroy
      render json: {}, status: :no_content
    end

    private

    def set_sale_tax
      @sale_tax = current_account.sale_taxes.find(params[:id])
    end

    def permitted_params
      params
        .require(:sale_tax)
        .permit(:name, :percent)
    end
  end
end
