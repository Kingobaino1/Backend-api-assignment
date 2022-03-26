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
  private

  def account_params
    params.permit(:username, :password)
  end
end
