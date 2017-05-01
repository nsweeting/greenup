module Decorators
  class Order
    include Decorator

    validate :validate_new_record

    decorate :number
    decorate :name

    private

    def number
      last_order + 1
    end

    def name
      "##{last_order + 1000}"
    end

    def validate_new_record
      return if object.new_record?
      errors.add(:object)
    end

    def last_order
      @last_order ||= object.account.orders.select(:number).last&.number || 0
    end
  end
end
