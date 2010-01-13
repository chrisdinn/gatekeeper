require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

SSO_URL = "http://ssourl.local/sso"

class TestApp < Sinatra::Base
  enable :sessions
  
  use Gatekeeper::Middleware do |sso|
    sso.sso_url = SSO_URL
  end
  
  get "/test" do
    "success"
  end
end
  
describe "Gatekeeper" do
  include Rack::Test::Methods    
  
  def app
    TestApp
  end

  describe "sso login" do
    it "should defer to SSO server for authentication" do
      get '/sso/login'
      
      last_response.should be_redirect
      last_response.headers['Location'].should == "#{SSO_URL}/login?return_to=http://example.org/sso/login"
    end
    
    it "should build OpenID header, when appropriate" do
      get '/sso/login', :id => 1
      
      last_response.status.should == 401
      last_response.body.should == 'got openid?'
      last_response.headers['WWW-Authenticate'].should == Rack::OpenID.build_header(
        :identifier => "#{SSO_URL}/users/1",
        :trust_root => "http://example.org/sso/login"
      )
    end
    
    it "should log in a user if OpenID authentication succeeds" do
      checkid_response = mock('OpenID response')
      message = mock('OpenID message')
      
      checkid_response.stub!(:status).and_return(:success)
      checkid_response.stub!(:display_identifier).and_return("#{SSO_URL}/users/1")

      message.stub!(:get_args).with("http://openid.net/extensions/sreg/1.1").and_return({'is_admin?' => false})
      checkid_response.stub!(:message).and_return(message)
    
      get '/sso/login', {}, 'rack.openid.response' => checkid_response
      
      last_response.should be_redirect
      last_response.headers['Location'].should == "/"
    end
    
  end
  
end
