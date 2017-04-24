module JsonErrors
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from Pundit::NotAuthorizedError, with: :forbidden
    rescue_from ActionController::RoutingError, with: :route_not_found
  end

  def resource_errors(errors)
    render json: { errors: errors.full_messages }.to_json, status: :unprocessable_entity
  end

  def record_not_found
    render json: { errors: ['Record not found'] }.to_json, status: :not_found
  end

  def route_not_found
    render json: { errors: ['Route not found'] }.to_json, status: :not_found
  end

  def not_authorized
    render json: { errors: ['Not authorized'] }.to_json, status: :unauthorized
  end

  def forbidden
    render json: { errors: ['Forbidden'] }.to_json, status: :forbidden
  end
end
