class Api::V1::AccountsController < ApplicationController
  def create
    @account = Account.new(account_params)
    if @account.save
      payload = { account_id: @account.id }
      token = encode_token(payload)
      render json: { account: @account, jwt: token, message: 'created' }, status: :created
    elsif Account.find_by(username: params[:username])
      render json: { errors: 'Account already exists', status: :not_acceptable }
    else
      render json: { errors: 'Account not created', status: :not_acceptable }
    end
  end

  def login
    @account = Account.find_by(username: params[:username])
    if @account &.authenticate(params[:password])
      payload = { account_id: @account.id }
      @token = encode_token(payload)
      render json: { user: @account, jwt: @token, message: 'login successful' }
    else
      render json: { error: 'Invalid username or password', status: :unauthorized }
    end
  end
  private

  def account_params
    params.permit(:username, :password)
  end
end
