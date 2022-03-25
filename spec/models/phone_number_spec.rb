require 'rails_helper'

RSpec.describe PhoneNumber, type: :model do
  it { is_expected.to validate_presence_of(:number) }
  it { is_expected.to validate_length_of(:number).is_at_least(6) }
  it { is_expected.to validate_length_of(:number).is_at_most(16) }
  it { should belong_to(:account) }
end
