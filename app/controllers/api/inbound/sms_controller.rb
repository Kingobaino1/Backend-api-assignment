class Api::Inbound::SmsController < ApplicationController
  before_action :authorized
  def create
    @to = PhoneNumber.find_by(number: query_params[:to])
    @from =  PhoneNumber.find_by(number: query_params[:from])
    account = logged_in_user.phone_numbers
    length_validation
  end

  private 

  def query_params
    params.permit(:to, :from, :text)
  end

  def phone_number(number)
    PhoneNumber.find_by(number: number)
  end
  def length_validation
    error = ''
    query_params.each do |key, value|
      if !value.is_a? String
        error = key + ' is invalid'
      elsif value.length == 0
        error = key + ' is missing'
      elsif (key == 'text') && (value.size > 120)
        error = key + ' is invalid 4'
      elsif (key == 'to' || key == 'from') && (value.size < 6 || value.size > 16)
        error = key + ' is invalid 3'
      end
    end
    render json: {message: '', error: error}
  end
end
