module V1
  class MemberSerializer < ApplicationSerializer
    cache key: 'member', expires_in: 3.hours

    attributes :id, :role, :scopes, :confirmed, :confirmation_email, :created_at, :updated_at

    belongs_to :user
  end
end
