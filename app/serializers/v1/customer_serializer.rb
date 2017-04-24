module V1
  class CustomerSerializer < ApplicationSerializer
    attributes :id, :email, :first_name, :last_name, :company, :total_spent,
               :last_order_id, :phone, :tax_exempt, :created_at, :updated_at

    has_many :addresses
  end
end
