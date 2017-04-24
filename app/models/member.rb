class Member < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :account

  enum role: [:basic, :owner, :admin]

  validates :user, presence: true, if: :confirmed
  validates :account, presence: true
  validates :confirmation_email, presence: true, unless: :confirmed

  scope :for_authentication, (lambda do |email, account|
    includes(:user, :account)
      .where(accounts: { name: account })
      .where(users: { email: email })
      .references(:accounts, :users)
  end)

  scope :for_authorization, (lambda do |id, user_id, account_id|
    includes(:user, :account)
      .where(id: id)
      .where(account_id: account_id)
      .where(user_id: user_id)
  end)
end
