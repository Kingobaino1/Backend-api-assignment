class Account < ApplicationRecord
  has_secure_password
  has_many :phone_numbers, dependent: :destroy
  validates :password_digest, presence: true
  validates :username, presence: true, uniqueness: true, length: { minimum: 3, maximum: 40 }
end
