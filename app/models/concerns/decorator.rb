module Decorator
  extend ActiveSupport::Concern

  include Assignable

  included do
    class << self
      def decorate(*args, **options)
        args.each do |attribute|
          decorations << [attribute, options]
        end
      end

      def decorations
        @decorations ||= []
      end
    end
  end

  def call
    return unless valid?
    assign_attributes(:decorations)
  end
end
