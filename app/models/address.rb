class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true, optional: true
  belongs_to :province
  belongs_to :country

  enum category: [:shipping, :billing]

  default_scope { includes(:province, :country) }

  with_options presence: true do
    validates :first_name, :last_name, :address_1, :city, :province, :country
  end
  validates_with Validators::PostalCode
  validate :validate_province

  private

  def validate_province
    return unless province.present?
    return if province.country == country
    errors.add(:province, 'must belong to selected country')
  end
end
