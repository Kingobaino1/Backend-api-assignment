class PhoneNumber < ApplicationRecord
  belongs_to :account
  validates :number, presence: true, length: { minimum: 6, maximum: 16 }
end
