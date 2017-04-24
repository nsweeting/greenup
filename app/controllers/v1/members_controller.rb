module V1
  class MembersController < ApplicationController
    before_action { authorize Member }
    before_action :set_member, only: [:show, :update, :destroy]

    def create
      member = current_account.members.new(permitted_params)
      if member.save
        render json: member, status: :created
      else
        resource_errors(member.errors)
      end
    end

    def index
      members = scopes_with_paging(current_account.members)
      render json: members, status: :ok
    end

    def show
      render json: @member, status: :ok
    end

    def update
      if @member.update_attributes(permitted_params)
        render json: @member, status: :ok
      else
        resource_errors(@member.errors)
      end
    end

    def destroy
      @member.destroy
      render json: {}, status: :no_content
    end

    private

    def set_member
      @member = current_account.members.find(params[:id])
    end

    def permitted_params
      params
        .require(:member)
        .permit(:confirmation_email, scopes: [])
    end
  end
end
