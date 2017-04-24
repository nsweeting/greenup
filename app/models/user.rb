class User < ApplicationRecord
  has_many :members

  has_secure_password

  validates :email, presence: true
  validates :email, uniqueness: true
end
