module Request
  module AuthHelpers
    def auth_headers(account)
      token = Knock::AuthToken.new(payload: { sub: account.id }).token
      {
        'Authorization': "Bearer #{token}"
      }
    end
  end
end