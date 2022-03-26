class Api::Inbound::SmsController < ApplicationController
  def create
    if logged_in_user
      @to = phone_number(query_params[:to])
      text = query_params[:text]
      from = query_params[:from]
      to = query_params[:to]
      if (to.size >= 6 && to.size <= 16 && from.size >= 6 && from.size <= 16 && text.size <= 120) &&
          from.is_a?(String) && text.is_a?(String) && to.is_a?(String) &&
          (text.split(' ').include?('STOP') && to != from && !@to.nil?)
        set_stop()
        single_stop()
        render json: { message: '', error: 'unknown failure' }  
      elsif (to.size >= 6 && to.size <= 16 && from.size >= 6 && from.size <= 16 && text.size <= 120) &&
             from.is_a?(String) && text.is_a?(String) && to.is_a?(String)
       found_number(@to, 'to', to, from, 'inbound sms ok')
      else
        return length_validation
      end
    else
      render json: { message: 'Not authorized' }
    end
  end
end
