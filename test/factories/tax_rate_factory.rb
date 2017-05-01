FactoryGirl.define do
  factory :tax_rate do
    name 'HST'
    amount 0.13
    before(:create) do |tax_rate, _|
      unless tax_rate.account.present?
        account = create(:account)
        tax_rate.account_id = account.id
      end
      unless tax_rate.zone.present?
        zone = create(:zone, account: tax_rate.account)
        tax_rate.zone_id = zone.id
      end
    end
  end
end
