class Zone < ApplicationRecord
  include Zoneable

  belongs_to :account
  with_options dependent: :destroy, inverse_of: :zone do
    has_many :zone_members
    has_many :tax_rates
    has_many :shipping_methods
  end
  with_options through: :zone_members, source: :zoneable do
    has_many :countries, source_type: 'Country'
    has_many :provinces, source_type: 'Province'
  end

  with_options presence: true do
    validates :name, :account
  end

  alias members zone_members

  has_zones :countries
  has_zones :provinces

  accepts_nested_attributes_for :zone_members, allow_destroy: true

  scope :province_matches, (lambda do |address|
    includes(:zone_members)
      .where(zone_members: { zoneable_type: 'Province', zoneable_id: address.province_id } )
  end)
  scope :country_matches, (lambda do |address|
    includes(:zone_members)
      .where(zone_members: { zoneable_type: 'Country', zoneable_id: address.country_id } )
  end)

  class << self
    def matches(address)
      return none unless address.is_a?(Address)
      province_matches(address).or(country_matches(address))
    end
  end
end
