module V1
  class OrdersController < ApplicationController
    before_action { authorize Order }
    before_action :set_order, only: [:show, :update, :destroy]

    def create
      order = current_account.orders.new(permitted_params)
      if order.save
        render json: order, status: :created
      else
        resource_errors(order.errors)
      end
    end

    def index
      orders = scopes_with_paging(current_account.orders)
      render json: orders, status: :ok
    end

    def show
      render json: @order, status: :ok
    end

    def update
      if @order.update_attributes(permitted_params)
        render json: @order, status: :ok
      else
        resource_errors(@order.errors)
      end
    end

    def destroy
      @order.destroy
      render json: {}, status: :no_content
    end

    private

    def set_order
      @order = current_account.orders.find(params[:id])
    end

    def permitted_params
      params
        .require(:order)
        .permit(:email)
    end
  end
end
