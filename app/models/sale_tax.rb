class SaleTax < ApplicationRecord
  belongs_to :account

  validates :name, presence: true
  validates :percent, presence: true
  validates_numericality_of :percent, greater_than: 0, less_than: 100
end
