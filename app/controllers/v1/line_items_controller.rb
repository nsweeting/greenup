module V1
  class LineItemsController < ApplicationController
    before_action { authorize Order }
    before_action :set_line_item, only: [:show, :update, :destroy]

    def create
      line_item = current_order.line_items.new(permitted_params)
      if line_item.save
        render json: line_item, status: :created
      else
        resource_errors(line_item.errors)
      end
    end

    def index
      line_items = scopes_with_paging(current_order.line_items)
      render json: line_items, status: :ok
    end

    def show
      render json: @line_item, status: :ok
    end

    def update
      if @line_item.update_attributes(permitted_params)
        render json: @line_item, status: :ok
      else
        resource_errors(@line_item.errors)
      end
    end

    def destroy
      @line_item.destroy
      render json: {}, status: :no_content
    end

    private

    def current_order
      current_account.orders.find(params[:order_id])
    end

    def set_line_item
      @line_item = current_order.line_items.find(params[:id])
    end

    def permitted_params
      params
        .require(:line_item)
        .permit(:title, :vendor, :grams, :quantity, :price, :total_discount,
                :currency, :taxable, :requires_shipping, :variant_id)
    end
  end
end
