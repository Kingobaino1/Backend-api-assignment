require 'rails_helper'

RSpec.describe Account, type: :model do
  it { is_expected.to validate_presence_of(:username) }
  it { is_expected.to validate_presence_of(:password_digest) }
  it { is_expected.to validate_length_of(:username).is_at_least(3) }
  it { is_expected.to validate_length_of(:username).is_at_most(40) }
  it { is_expected.to validate_uniqueness_of(:username) }
  it { should have_secure_password }
  it { should have_many(:phone_numbers) }
end
