module V1
  class UserSerializer < ApplicationSerializer
    cache key: 'user', expires_in: 3.hours

    attributes :id, :email, :first_name, :last_name, :created_at, :updated_at
  end
end
