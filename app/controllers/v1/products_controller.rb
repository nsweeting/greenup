module V1
  class ProductsController < ApplicationController
    before_action { authorize Product }
    before_action :set_product, only: [:show, :update, :destroy]

    def create
      product = current_account.products.new(permitted_params)
      if product.save
        render json: product, status: :created
      else
        resource_errors(product.errors)
      end
    end

    def index
      products = scopes_with_paging(current_account.products)
      render json: products, status: :ok
    end

    def show
      render json: @product, status: :ok
    end

    def update
      if @product.update_attributes(permitted_params)
        render json: @product, status: :ok
      else
        resource_errors(@product.errors)
      end
    end

    def destroy
      @product.destroy
      render json: {}, status: :no_content
    end

    private

    def set_product
      @product = current_account.products.find(params[:id])
    end

    def permitted_params
      params
        .require(:product)
        .permit(:title)
    end
  end
end
