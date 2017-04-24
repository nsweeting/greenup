FactoryGirl.define do
  factory :line_item do
    before(:create) do |line_item, _|
      unless line_item.order.present?
        order = create(:order)
        line_item.order_id = order.id
      end
      unless line_item.variant.present?
        product = create(:product, account: line_item.order.account)
        variant = create(:variant, product: product)
        line_item.variant_id = variant.id
      end
    end
  end
end
