require 'rails_helper'

RSpec.describe "Api::V1::PhoneNumbers", type: :request do
  describe "Post /create" do
    before do
      @user = Account.create(username: 'John', password: 'password')
      post '/api/v1/phone_numbers', params: { account_id: @user.id, number: '1234567' }
    end
  
    it 'returns the phone number\'s number' do
      expect(JSON.parse(response.body)['number']).to eq('1234567')
    end
  
    it 'returns the phone number\'s account id' do
      expect(JSON.parse(response.body)['account_id']).to eq(@user.id)
    end

    it 'returns a created status' do
      expect(response).to have_http_status(:ok)
    end
  end
  
  describe "GET /index" do
    before do
      @account = Account.create(username: 'John Doe', password: 'password')
      @num1 = PhoneNumber.create(account_id: @account.id, number: '1234567')
      @num2 = PhoneNumber.create(account_id: @account.id, number: '12345678')
      get '/api/v1/phone_numbers'
    end
    it 'returns all phone_numbers' do
      expect(JSON.parse(response.body).size).to eq(2)
    end
    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end
  end
end
