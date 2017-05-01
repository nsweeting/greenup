module Zoneable
  extend ActiveSupport::Concern

  module ClassMethods
    def has_zones(named)
      define_method "#{named}_attributes=" do |attributes|
        attributes = attributes.collect do |a|
          {
            zoneable_type: named.to_s.classify,
            zoneable_id: a[:id]
          }
        end
        self.zone_members_attributes = attributes
      end
    end
  end

  def zone_members_attributes=(attributes)
    attributes = attributes.uniq { |m| [m[:zoneable_id], m[:zoneable_type]] }
    current_members = members.pluck(:zoneable_id, :zoneable_type)
    attributes = attributes.delete_if do |m|
      current_members.include?([m[:zoneable_id], m[:zoneable_type]])
    end
    super(attributes)
  end
end
