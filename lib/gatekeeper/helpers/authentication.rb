module Gatekeeper
  module Helpers
    module Authentication
      def current_user?
        session[:sso] && !session[:sso][:user_id].nil?
      end
      
      def is_admin?
        (session[:sso][:is_admin?]=='true')
      end

      def is_manager_for?(hotink_account_id)
        (session[:sso]["account_#{hotink_account_id.to_s}_manager".to_sym]=='true')
      end
    end
  end
end