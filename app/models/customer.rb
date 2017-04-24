class Customer < ApplicationRecord
  belongs_to :account
  has_many :addresses, class_name: Address, as: :addressable
  has_many :orders

  monetize :total_spent_cents

  validates :account, presence: true
  validates :email, presence: true
  validates_uniqueness_of :email, scope: :account_id
end
