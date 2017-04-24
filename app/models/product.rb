class Product < ApplicationRecord
  belongs_to :account
  has_many :variants

  enum published_scope: [:internal, :merchant], _prefix: :published
end
