module V1
  class ZoneSerializer < ApplicationSerializer
    attributes :id, :name, :description, :created_at, :updated_at

    has_many :countries
    has_many :provinces
  end
end
