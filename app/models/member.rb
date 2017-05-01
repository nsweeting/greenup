class Member < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :account

  enum role: [:basic, :owner, :admin]

  validates :user, presence: true, if: :confirmed
  validates :account, presence: true
  validates :confirmation_email, presence: true, unless: :confirmed
  validates_uniqueness_of :user_id, scope: :account_id, if: proc { |m| m.user.present? }

  scope :for_authentication, (lambda do |email, account|
    includes(:user, :account)
      .where(accounts: { name: account })
      .where(users: { email: email })
      .references(:accounts, :users)
  end)

  scope :for_authorization, (lambda do |id, user_id, account_name|
    includes(:user, :account)
      .where(id: id)
      .where(accounts: { name: account_name })
      .where(user_id: user_id)
      .references(:accounts)
  end)
end
