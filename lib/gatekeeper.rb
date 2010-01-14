require 'sinatra/base'
require 'openid'
require 'openid/store/filesystem'
require 'rack/openid'
require 'tmpdir'

require File.dirname(__FILE__)+'/gatekeeper/helpers/rack'
require File.dirname(__FILE__)+'/gatekeeper/sso'
require File.dirname(__FILE__)+'/gatekeeper/middleware'