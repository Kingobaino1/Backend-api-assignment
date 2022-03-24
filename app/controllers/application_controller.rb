class ApplicationController < ActionController::API
  before_action :authorized

  def encode_token(payload)
    JWT.encode(payload, jwt_key)
  end

  def auth_header
    request.headers['Authorization']
  end

  def decoded_token
    if auth_header
      token = auth_header.split(' ')[1]
      begin
        JWT.decode(token, jwt_key, true, algorithm: 'HS256')
      rescue JWT::DecodeError
        nil
      end
    end
  end

  def logged_in_user
    if decoded_token
      user_id = decoded_token[0]['account_id']
      @account = Account.find_by(id: user_id)
    end
  end

  def logged_in?
    !!logged_in_user
  end

  def authorized
    render json: { message: 'Please log in' }, status: :unauthorized unless logged_in?
  end

  def jwt_key
    ENV['SESSION_SECRET']
  end 

  def length_validation
    error = ''
    query_params.each do |key, value|
      if !value.is_a? String
        error = key + ' is invalid'
      elsif value.length == 0
        error = key + ' is missing'
      elsif (key == 'text') && (value.size > 120)
        error = key + ' is invalid '
      elsif (key == 'to' || key == 'from') && (value.size < 6 || value.size > 16)
        error = key + ' is invalid '
      end
    end
     render json: { message: '', error: error }
  end

  def found_number(param, name, to, from)
    if param.nil?
      render json: { message: '', error: name + ' parameter not found1' }
    elsif param.account_id != logged_in_user.id
      render json: { message: '', error: name + ' parameter not found' }
    elsif to == from
      render json: { message: '', error: 'unknown failure'}
    else
      render json: { message: 'inbound sms ok', error: '' }
    end
  end

  def phone_number(number)
    PhoneNumber.find_by(number: number)
  end

  def query_params
    params.permit(:to, :from, :text)
  end

  def set_stop
    from = query_params[:from]
    to = phone_number(query_params[:to]).number
    $redis.mapped_hmset 'STOP', { "#{to}": from }
    $redis.expire('STOP', 14400)
  end

  def single_stop
    from = query_params[:from]
    to = phone_number(query_params[:to]).number
    $redis.set("#{to}", from)
    $redis.expire("#{to}", 86400)
  end

  def get_stop
    error = ''
    to = query_params[:to]
    from = query_params[:from]
    stop_hash = $redis.hgetall 'STOP'
    stop_hash.each do |key, value|
      if to != key && 'to' != key && from == value
        error = creation_time(time_now(), value)
      elsif to == key && from == value
        error = "sms from #{from} to #{to} blocked by STOP request here"
      end
    end
    render json: { message: '', error: error }
  end

  def count
    count = 0
    stop_hash = $redis.hgetall 'STOP'
    stop_hash.each do |key, value|
      if query_params[:from] == value
        count += 1
      end
    end
    return count
  end

  def time_now
    first_from = ''
    stop_hash = $redis.hgetall 'STOP'
    stop_hash.each do |key, value|
      if query_params[:from] == value
        first_from = key
      end
      break
    end
      return first_from
  end
  
  def creation_time(key, value)
  error = ''
  ttl = $redis.ttl(key) 
  if count() >= 2 && ttl <= 86400
    error = "limit reached for from #{value}"
  end
  error
  end
end
