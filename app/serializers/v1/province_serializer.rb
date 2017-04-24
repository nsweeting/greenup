module V1
  class ProvinceSerializer < ApplicationSerializer
    attributes :id, :name, :abbr, :country_id
  end
end
