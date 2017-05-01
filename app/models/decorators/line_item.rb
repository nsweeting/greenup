module Decorators
  class LineItem
    include Decorator

    validate :validate_variant
    validate :validate_new_record

    decorate :variant_title, if: :blank?
    with_options from: :product, if: :blank? do
      decorate :title, :vendor
    end
    with_options from: :variant, if: :zero? do
      decorate :grams, :price_cents
    end
    with_options from: :variant, if: :nil? do
      decorate :taxable, :requires_shipping, :currency
    end

    delegate :variant, to: :object
    delegate :product, to: :variant

    private

    def variant_title
      variant.title
    end

    def validate_variant
      return if variant.present?
      errors.add(:variant)
    end

    def validate_new_record
      return if object.new_record?
      errors.add(:object)
    end
  end
end
