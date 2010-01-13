module Keymaster
  module Client
    class Middleware < Sinatra::Base
      enable :raise_errors
      disable :show_exceptions

      set :sso_url, nil
      set :exclude_paths, nil

      def sso_url=(url)
        options.sso_url = url
      end
      
      register ::Keymaster::Client::SSO
    end
  end
end
