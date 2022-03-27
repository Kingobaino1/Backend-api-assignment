require 'rails_helper'

RSpec.describe "Api::V1::Accounts", type: :request do
  before do
   @user =  post '/api/v1/accounts', params: { username: 'Dike', password: 'password' }
  end

  def login(username, password)
    @user =  post '/api/v1/login', params: { username: username, password: password }
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

  it 'user can login' do
    login('Dike', 'password')
    expect(JSON.parse(response.body)['user']['username']).to eql('Dike')
  end

  it 'display correct login message' do
    login('Dike', 'password')
    expect(JSON.parse(response.body)['message']).to eql('login successful')
  end

  it 'display incorrect login error message when password is wrong' do
    login('Dike', 'passwor')
    expect(JSON.parse(response.body)['error']).to eql('Invalid username or password')
  end

  it 'display incorrect login error message when username is wrong' do
    login('joe', 'password')
    expect(JSON.parse(response.body)['error']).to eql('Invalid username or password')
  end

  it 'returns a JWT token on successful login' do
    login('Dike', 'password')
    expect(JSON.parse(response.body)['jwt']).not_to be(nil)
  end
end
  