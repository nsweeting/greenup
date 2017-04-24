FactoryGirl.define do
  factory :sale_tax do
    name 'HST'
    percent 13
    before(:create) do |sale_tax, _|
      unless sale_tax.account.present?
        account = create(:account)
        sale_tax.account_id = account.id
      end
    end
  end
end
