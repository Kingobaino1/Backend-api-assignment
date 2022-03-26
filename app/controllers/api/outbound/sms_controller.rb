class Api::Outbound::SmsController < ApplicationController
  def create
    if logged_in_user
      @from = phone_number(query_params[:from])
      text = query_params[:text]
      from = query_params[:from]
      to = query_params[:to]
      if (to.size >= 6 && to.size <= 16 && from.size >= 6 && from.size <= 16 && text.size <= 120) &&
          from.is_a?(String) && text.is_a?(String) && to.is_a?(String) &&
          text.split(' ').include?('STOP') && !@from.nil?
        get_stop() 
      elsif (to.size >= 6 && to.size <= 16 && from.size >= 6 && from.size <= 16 && text.size <= 120) &&
             from.is_a?(String) && text.is_a?(String) && to.is_a?(String) && time_now() != to
       found_number(@from, 'from', to, from, 'outbound sms ok')
      elsif (to.size >= 6 && to.size <= 16 && from.size >= 6 && from.size <= 16 && text.size <= 120) &&
             from.is_a?(String) && text.is_a?(String) && to.is_a?(String)
        render json: { message: '', error: "sms from #{from} to #{to} blocked by STOP request here"}
      else
        return length_validation
      end
    else
      render json: { message: 'Not authorized' }
    end
  end

  private 

  def query_params
    params.permit(:to, :from, :text)
  end
end
