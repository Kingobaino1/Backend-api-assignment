class Api::Outbound::SmsController < ApplicationController
  def index
    @accounts = Account.all

    render json: {user: @accounts, message: 'outbounds'}
  end
end
