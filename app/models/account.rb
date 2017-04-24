class Account < ApplicationRecord
  has_many :products
  has_many :variants, through: :products
  has_many :members
  has_many :users, through: :members
  has_many :customers
  has_many :addresses, through: :customers
  has_many :sale_taxes
  has_many :orders
  has_many :line_items, through: :orders

  validates :name, presence: true
  validates :name, uniqueness: true
end
