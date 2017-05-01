class Account < ApplicationRecord
  include Addressable

  has_many :products
  has_many :variants, through: :products
  has_many :members
  has_many :users, through: :members
  has_many :customers
  has_many :addresses, through: :customers
  has_many :tax_rates
  has_many :orders
  has_many :line_items, through: :orders
  has_many :zones
  has_many :shipping_methods
  has_many :shipping_accounts

  has_address :origin

  validates :name, presence: true
  validates :name, uniqueness: true
end
