require 'rails_helper'

RSpec.describe "Api::V1::Accounts", type: :request do
  before do
   @user =  post '/api/v1/accounts', params: { username: 'Dike', password: 'password' }
  end

  it 'returns the accounts\'s username' do
    expect(JSON.parse(response.body)['account']['username']).to eq('Dike')
  end

  it 'returns the account\'s password' do
    expect(JSON.parse(response.body)['account']['password_digest']).not_to be(nil)
  end

  it 'returns the account\'s token' do
    expect(JSON.parse(response.body)['jwt']).not_to be(nil)
  end

  it 'returns a created status' do
    expect(response).to have_http_status (:created)
  end
end

  