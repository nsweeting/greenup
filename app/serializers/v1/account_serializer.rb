module V1
  class AccountSerializer < ApplicationSerializer
    attributes :id, :name, :owner_email, :owner_name, :website, :created_at, :updated_at
  end
end
