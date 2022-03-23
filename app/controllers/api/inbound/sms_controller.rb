class Api::Inbound::SmsController < ApplicationController
  before_action :authorized
  def create
    @to = PhoneNumber.find_by(number: query_params[:to])
    text = query_params[:text]
    from = query_params[:from]
    to = query_params[:to]
    if (to.size >= 6 && to.size <= 16 && from.size >= 6 && from.size <= 16 && text.size <= 120) && from.is_a?(String) && text.is_a?(String) && to.is_a?(String)
      if @to.nil?
        render json: { message: '', error: 'to parameter not found' }
      elsif @to.account_id != logged_in_user.id
        render json: { message: '', error: 'to parameter not found' }
      else 
        render json: { message: 'inbound sms ok', error: '' }
      end
    else
      return length_validation
    end
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
     render json: { message: '', error: error }
  end
end
