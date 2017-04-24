FactoryGirl.define do
  factory :customer do
    sequence(:email) { |n| "test#{n}@email.com" }
    first_name 'Billy'
    last_name 'Bob'
    company 'Test'
    orders_count 1
    total_spent 10.00
    before(:create) do |customer, _|
      unless customer.account.present?
        account = create(:account)
        customer.account_id = account.id
      end
    end
  end
end
