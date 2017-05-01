class ZoneMember < ApplicationRecord
  VALID_TYPES = %w(Country Province).freeze

  belongs_to :zone, inverse_of: :zone_members
  belongs_to :zoneable, polymorphic: true, optional: true

  with_options presence: true do
    validates :zone, :zoneable
  end
  validates_inclusion_of :zoneable_type, in: VALID_TYPES
  validates :zone_id, uniqueness: { scope: [:zoneable_id, :zoneable_type] }
end
