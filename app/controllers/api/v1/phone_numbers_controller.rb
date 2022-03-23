class Api::V1::PhoneNumbersController < ApplicationController
  skip_before_action :authorized

  def index
    @numbers = PhoneNumber.all
    render json: @numbers
  end
  def create
    @phone_number = PhoneNumber.new(number_params)
    if @phone_number.save
      render json: @phone_number
    else
      render json: {error: 'Numbber not added to this account'}
    end
  end

  private

  def number_params
    params.permit(:account_id, :number)
  end
end
