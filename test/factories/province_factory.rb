FactoryGirl.define do
  factory :province do
    name 'Ontario'
    abbr 'ON'
    before(:create) do |province, _|
      unless province.country.present?
        country = create(:country)
        province.country_id = country.id
      end
    end
  end
end
