FactoryGirl.define do
  factory :shipping_service do
    name '1-Day Ground'
    before(:create) do |shipping_service, _|
      unless shipping_service.carrier.present?
        shipping_carrier = create(:shipping_carrier)
        shipping_service.shipping_carrier_id = shipping_carrier.id
      end
    end
  end
end
