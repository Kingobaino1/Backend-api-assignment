require 'rails_helper'

RSpec.describe "Api::Inbound::Sms", type: :request do
  def json
    @user = post '/api/v1/accounts',  params: { username: 'jondoe', password: 'password'}
    json = JSON.parse(response.body)['jwt']
    json
  end

  def login_account
    user =  Account.create(username: 'user1', password: 'password')
    @user = post '/api/v1/login',  params: { username: 'user1', password: 'password'}
    jwt = JSON.parse(response.body)['jwt']
    user_id = JSON.parse(response.body)['user']['id']
    token = { 'jwt' => jwt, 'id' => user_id }
    token
  end

  def number(from, to, text)
    url = post '/api/inbound/sms', params: { from: from, to: to, text: text }, headers: { 'Authorization': "Bearer #{json()}" }
    url
  end
  it 'Not allow an authorized user' do
    post '/api/inbound/sms', params: { from: '', to: '12345678', text: 'I love programming' }
    expect(JSON.parse(response.body)['message']).to eq('Not authorized')
  end

  it 'validates from input' do
    number('', '123456', 'I love programming')
    expect(JSON.parse(response.body)['error']).to eq('from is missing')
  end

  it 'validates to input' do
    number('123456', '', 'I love programming')
    expect(JSON.parse(response.body)['error']).to eq('to is missing')
  end

  it 'checks that to input exists for this account' do
    number('123456', '1234567', 'I love programming')
    expect(JSON.parse(response.body)['error']).to eq('to parameter not found')
  end

   it 'validates the length of from input' do
    number('123', '1234567', 'I love programming')
    expect(JSON.parse(response.body)['error']).to eq('from is invalid')
  end

  it 'validates the length of to input' do
    number('123456', '123', 'I love programming')
    expect(JSON.parse(response.body)['error']).to eq('to is invalid')
  end

  it 'checks that from input exists in phone number database' do
    PhoneNumber.create(account_id: login_account()['id'], number: '123456')
    post '/api/inbound/sms', params: { from: '1234567', to: '123456', text: 'I love programming' }, headers: { 'Authorization': "Bearer #{login_account()['jwt']}" }
    expect(JSON.parse(response.body)['error']).to eq('1234567 parameter not found in the database')
  end

  it 'save from and to inputs to redis and returns error message' do
    user =  Account.create(username: 'user2', password: 'password')
    PhoneNumber.create(account_id: user.id, number: '1234567')
    PhoneNumber.create(account_id: login_account()['id'], number: '123456')
    post '/api/inbound/sms', params: { from: '1234567', to: '123456', text: 'STOP sms now' }, headers: { 'Authorization': "Bearer #{login_account()['jwt']}" }
    expect(JSON.parse(response.body)['error']).to eq('unknown failure')
  end

  it 'send the inbound sms' do
    user =  Account.create(username: 'user2', password: 'password')
    PhoneNumber.create(account_id: user.id, number: '1234567')
    PhoneNumber.create(account_id: login_account()['id'], number: '123456')
    post '/api/inbound/sms', params: { from: '1234567', to: '123456', text: 'inbound sms is okay now' }, headers: { 'Authorization': "Bearer #{login_account()['jwt']}" }
    expect(JSON.parse(response.body)['message']).to eq('inbound sms ok')
  end
end
