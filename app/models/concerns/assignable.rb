module Assignable
  extend ActiveSupport::Concern

  include ActiveModel::Validations

  included do
    class << self
      def assign!(object)
        assignable = new(object)
        assignable.call
        assignable.assign
        object
      end

      def update!(object)
        assignable = new(object)
        assignable.call
        assignable.update
        object
      end
    end
  end

  attr_reader :object, :attributes

  def initialize(object)
    @object      = object
    @attributes  = {}
  end

  def update
    object.update_columns(attributes.merge(updated_at: Time.now))
  end

  def save

  end

  def assign
    object.attributes = attributes
  end

  private

  def assign_attributes(method)
    self.class.send(method).each do |attr, opts|
      if opts[:if]
        next unless object.send(attr).send(opts[:if])
      end
      if opts[:unless]
        next if object.send(attr).send(opts[:unless])
      end
      assign_attribute(attr, opts)
    end
  end

  def assign_attribute(attr, opts)
    attributes[attr] = opts[:from] ? send(opts[:from]).send(attr) : send(attr)
  end
end
