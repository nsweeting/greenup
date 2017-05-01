FactoryGirl.define do
  factory :shipping_account do
    credentials(key: 'test')
    before(:create) do |shipping_account, _|
      unless shipping_account.account.present?
        account = create(:account)
        shipping_account.account_id = account.id
      end
      unless shipping_account.shipping_carrier.present?
        shipping_carrier = create(:shipping_carrier)
        shipping_account.shipping_carrier_id = shipping_carrier.id
      end
    end
  end
end
