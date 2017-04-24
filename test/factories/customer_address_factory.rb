FactoryGirl.define do
  factory :customer_address, class: Address do
    first_name 'John'
    last_name 'Doe'
    address_1 '37 Winthorpe Rd'
    city 'Toronto'
    postal_code 'M4E 2Y5'
    before(:create) do |address, _|
      unless address.province.present?
        province = create(:province)
        address.province_id = province.id
        address.country_id = province.country_id
      end
      unless address.addressable.present?
        customer = create(:customer)
        address.addressable = customer
      end
    end
  end
end
