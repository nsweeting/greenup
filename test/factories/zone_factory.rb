FactoryGirl.define do
  factory :zone do
    name 'Ontario'
    description 'The Province of Ontario, Canada'
    before(:create) do |zone, _|
      unless zone.account.present?
        account = create(:account)
        zone.account_id = account.id
      end
    end
  end
end
