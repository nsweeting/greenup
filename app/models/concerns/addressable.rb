module Addressable
  extend ActiveSupport::Concern

  module ClassMethods
    def has_address(named)
      has_one :"#{named}_address", -> { where(category: named) }, {
        class_name: Address,
        as: :addressable
      }

      define_method "#{named}_address=" do |record|
        record.category = named
        super(record)
      end

      define_method "#{named}_address_attributes=" do |attributes|
        attributes[:category] = named
        super(attributes)
      end
    end
  end
end
