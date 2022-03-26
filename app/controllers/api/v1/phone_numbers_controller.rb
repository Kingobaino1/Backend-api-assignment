class Api::V1::PhoneNumbersController < ApplicationController
  skip_before_action :authorized

  def index
    @numbers = PhoneNumber.all
    render json: @numbers
  end

  def create
    @number_exist = phone_number(params[:number])
    if @number_exist && @number_exist.account_id == params[:account_id]
       render json: { error: 'This number already exist for this account' }
    else
      @phone_number = PhoneNumber.new(number_params)
      if @phone_number.save
        render json: @phone_number
      else
        render json: { error: @phone_number.errors.full_messages.last }
      end
    end
  end

  private

  def number_params
    params.permit(:account_id, :number)
  end
end
