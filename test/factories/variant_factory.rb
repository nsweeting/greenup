FactoryGirl.define do
  factory :variant do
    title '10 grams'
    sku '111111'
    position 1
    grams 10
    taxable true
    inventory 1
    old_inventory 0
    price_cents 1000
    before(:create) do |variant, _|
      unless variant.account.present?
        account = create(:account)
        variant.account_id = account.id
      end
      unless variant.product.present?
        product = create(:product, account: variant.account)
        variant.product_id = product.id
      end
    end
  end
end
