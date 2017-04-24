FactoryGirl.define do
  factory :product do
    title 'weed'
    product_type 'weed'
    slug 'weed'
    vendor 'Weed Inc.'
    published true
    published_scope :merchant
    body_html '<b>Great!</b>'
    before(:create) do |product, _|
      unless product.account.present?
        account = create(:account)
        product.account_id = account.id
      end
    end
  end
end
