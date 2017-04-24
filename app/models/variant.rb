class Variant < ApplicationRecord
  belongs_to :product

  delegate :account, to: :product

  monetize :price_cents, with_model_currency: :currency
end
