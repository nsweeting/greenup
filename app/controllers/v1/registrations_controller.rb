module V1
  class RegistrationsController < ApplicationController
    skip_before_action :authenticate_request

    def create
      registration = Registration.new(permitted_params)
      if registration.save
        render json: registration, status: :created
      else
        resource_errors(registration.merged_errors)
      end
    end

    private

    def permitted_params
      params
        .require(:registration)
        .permit(:name, :email, :password, :password_confirmation)
    end
  end
end
