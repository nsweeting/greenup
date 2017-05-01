class TaxRate < ApplicationRecord
  belongs_to :account
  belongs_to :zone

  with_options presence: true do
    validates :account, :zone, :name, :amount
  end
  validates_numericality_of :amount, greater_than: 0.0, less_than: 1.0
  validate :validate_zone_account

  private

  def validate_zone_account
    return unless zone.present?
    return if account == zone.account
    errors.add(:zone, 'must belong to your account')
  end
end
