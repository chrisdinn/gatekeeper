module Gatekeeper
  module Client
    class Middleware < Sinatra::Base
      enable :raise_errors
      disable :show_exceptions

      set :sso_url, nil
      set :exclude_paths, nil

      def sso_url=(url)
        options.sso_url = url
      end
      
      register ::Gatekeeper::Client::SSO
    end
  end
end
