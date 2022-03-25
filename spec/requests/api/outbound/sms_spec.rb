require 'rails_helper'

RSpec.describe "Api::Outbound::Sms", type: :request do
  before(:each) do
    post '/api/outbound/sms', params: { from: '123456', to: '12345678', text: 'I love programming' }
  end
  it 'Not allow an authorized user' do
    expect(JSON.parse(response.body)['message']).to eq('Not authorized')
  end
end
