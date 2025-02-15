require 'sinatra/base'

module Sinatra
  module AuthenticationHelper
    def authenticate!
      user = authenticate_user_by_basic_authentication
      return user if user
      
      content_type :text
      headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
      halt(401, "Not authorized\n")
    end

    def authenticate_user_by_basic_authentication
      auth = get_basic_auth
      return false unless auth.provided? && auth.basic? && auth.credentials

      user = find_user_by_login(auth.username)
      user && user.authenticate(auth.credentials[1]) ? user : false
    end

    def get_basic_auth
      Rack::Auth::Basic::Request.new(request.env)
    end

    def find_user_by_login(login)
      User.find_by(:login => login)
    end
  end

  helpers AuthenticationHelper
end