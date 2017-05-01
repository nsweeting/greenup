class ShippingMethod < ApplicationRecord
  belongs_to :account
  belongs_to :zone
  belongs_to :shipping_service

  delegate :shipping_carrier, to: :shipping_service

  with_options presence: true do
    validates :account, :zone, :shipping_service, :name
  end
  validate :validate_zone_account

  private

  def validate_zone_account
    return unless zone.present?
    return if account == zone.account
    errors.add(:zone, 'must belong to your account')
  end
end
