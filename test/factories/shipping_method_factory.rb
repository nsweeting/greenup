FactoryGirl.define do
  factory :shipping_method do
    name 'Canada Post - 1-day'
    before(:create) do |shipping_method, _|
      unless shipping_method.account.present?
        account = create(:account)
        shipping_method.account_id = account.id
      end
      unless shipping_method.zone.present?
        zone = create(:zone, account: shipping_method.account)
        shipping_method.zone_id = zone.id
      end
      unless shipping_method.shipping_service.present?
        shipping_service = create(:shipping_service)
        shipping_method.shipping_service_id = shipping_service.id
      end
    end
  end
end
