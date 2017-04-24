module V1
  class AddressSerializer < ApplicationSerializer
    attributes :id, :address_1, :address_2, :city, :company, :first_name,
               :last_name, :phone, :postal_code

    belongs_to :province
    belongs_to :country
  end
end
