FactoryGirl.define do
  factory :member do
    role :owner
    confirmed true
    before(:create) do |member, _|
      unless member.account.present?
        account = create(:account)
        member.account_id = account.id
      end
      unless member.user.present?
        user = create(:user)
        member.user_id = user.id
      end
    end
  end
end
