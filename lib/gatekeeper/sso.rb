module Gatekeeper
  module SSO
    def self.registered(app)
      app.use(Rack::OpenID, OpenID::Store::Filesystem.new("#{Dir.tmpdir}/openid"))
      app.helpers Gatekeeper::Helpers::Rack

      app.get '/sso/login' do
        if contact_id = params['id']
          response['WWW-Authenticate'] = Rack::OpenID.build_header(
            :identifier => "#{options.sso_url}/users/#{contact_id}",
            :trust_root => absolute_url('/sso/login')
          )
          throw :halt, [401, 'got openid?']
        elsif openid = request.env["rack.openid.response"]
          if openid.status == :success
            if contact_id = openid.display_identifier.split("/").last
              sreg_params = openid.message.get_args("http://openid.net/extensions/sreg/1.1")
              sso_login_as(contact_id, sreg_params)
              
              if session['sso_return_to']
                begin
                  session_url = session['sso_return_to']
                  session['sso_return_to'] = nil
                  return_url = URI.parse(session_url)
                  
                  unless return_url.host==request.host
                    user_token = UserToken.create!(:user_id => sso_user_id, :email => sso_user_email)
                    if return_url.query==nil
                      return_url.query = "user_token=#{user_token.token}"
                    else
                      return_url.query = "user_token=#{user_token.token}&#{return_url.query}"
                    end
                  end
                  redirect return_url.to_s   
                rescue
                  redirect '/'
                end
              else
                redirect '/'
              end
            
            else
              raise "No contact could be found for #{openid.display_identifier}"
            end
          else
            throw :halt, [503, "Error: #{openid.status}"]
          end
        else
          session['sso_return_to'] = params[:return_to] if params[:return_to]
          redirect "#{options.sso_url}/login?return_to=#{absolute_url('/sso/login')}"
        end
      end

      app.get '/sso/logout' do
        session[:sso] = nil
        redirect "#{options.sso_url}/logout"
      end
    end
  end
end
