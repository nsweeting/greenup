module V1
  class VariantsController < ApplicationController
    before_action { authorize Variant }
    before_action :set_variant, only: [:show, :update, :destroy]

    def create
      variant = current_product.variants.new(permitted_params)
      if variant.save
        render json: variant, status: :created
      else
        resource_errors(variant.errors)
      end
    end

    def index
      variants = scopes_with_paging(current_product.variants)
      render json: variants, status: :ok
    end

    def show
      render json: @variant, status: :ok
    end

    def update
      if @variant.update_attributes(permitted_params)
        render json: @variant, status: :ok
      else
        resource_errors(@variant.errors)
      end
    end

    def destroy
      @variant.destroy
      render json: {}, status: :no_content
    end

    private

    def current_product
      current_account.products.find(params[:product_id])
    end

    def set_variant
      @variant = current_product.variants.find(params[:id])
    end

    def permitted_params
      params
        .require(:variant)
        .permit(:title)
    end
  end
end
