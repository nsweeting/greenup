FactoryGirl.define do
  factory :account do
    sequence(:owner_email) { |n| "test#{n}@email.com" }
    sequence(:name) { |n| "account#{n}" }
  end
end
