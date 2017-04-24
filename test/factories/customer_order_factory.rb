FactoryGirl.define do
  factory :customer_order do
    before(:create) do |customer_order, _|
      unless customer_order.customer.present?
        customer = create(:customer)
        customer_order.customer_id = customer.id
      end
      unless customer_order.order.present?
        customer = create(:order)
        customer_order.order_id = order.id
      end
      unless customer_order.billing_address.present?
        billing_address = create(:address, customer: customer, category: :billing, default: true)
        customer_order.billing_address_id = billing_address.id
      end
      unless customer_order.shipping_address.present?
        shipping_address = create(:address, customer: customer, category: :shipping, default: true)
        customer_order.shipping_address_id = shipping_address.id
      end
    end
  end
end
