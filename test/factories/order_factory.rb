FactoryGirl.define do
  factory :order do
    total_price_cents 1000
    before(:create) do |order, _|
      unless order.account.present?
        account = create(:account)
        order.account_id = account.id
      end
    end
  end
end
