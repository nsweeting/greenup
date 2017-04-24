module V1
  class RegistrationSerializer < ApplicationSerializer
    has_one :user
    has_one :member
    has_one :account
  end
end