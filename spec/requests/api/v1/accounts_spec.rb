require 'rails_helper'

RSpec.describe "Api::V1::Accounts", type: :request do
  before do
    post '/api/v1/accounts', params: { username: 'Dike', password: 'password' }
  end

  it 'returns the accounts\'s username' do
    expect(JSON.parse(response.body)['account']['username']).to eq('Dike')
  end

  it 'returns the account\'s password' do
    expect(JSON.parse(response.body)['account']['password']).should be(String)
  end

  it 'returns the account\'s token' do
    expect(JSON.parse(response.body)['jwt']).should be(object)
  end

  # it 'returns a created status' do
  #   expect(response).to have_http_status(:ok)
  # end
# end
end

  