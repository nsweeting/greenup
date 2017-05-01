module Calculator
  extend ActiveSupport::Concern

  include Assignable

  included do
    class << self
      def calculate(*args, **options)
        args.each do |attribute|
          calculations << [attribute, options]
        end
      end

      def calculations
        @calculations ||= []
      end
    end
  end

  def call
    return unless valid?
    assign_attributes(:calculations)
  end
end
