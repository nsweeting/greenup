module V1
  class ApplicationController < ActionController::API
    include Pundit
    include JsonErrors

    serialization_scope :view_context

    before_action :authenticate_request

    private

    attr_reader :current_member

    def authenticate_request
      auth = Security::Authorize.call(request.headers)
      if auth.valid?
        @current_member = auth.member
      else
        not_authorized
      end
    end

    def current_account
      current_member.account
    end

    def current_user
      current_member.user
    end

    def pundit_user
      current_member
    end

    def scopes_with_paging(resource)
      apply_scopes(paging(resource))
    end

    def paging(resource)
      page = params[:page] || 1
      limit = params[:limit] || 20
      resource.page(page).per(limit)
    end
  end
end
