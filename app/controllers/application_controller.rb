# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  helper_method :current_user, :logged_in?

  def sort_order(default)
    "#{(params[:c] || default.to_s).gsub(/[\s;'\"]/,'')} #{params[:d] == 'down' ? 'DESC' : 'ASC'}"
  end

  protected
    def authenticate
      unless logged_in?
        store_location
        redirect_to new_session_path
      end
    end
    
    def current_user
      @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
    end
    
    def current_user=(user)
      session[:user_id] = user ? user.id : nil
      @current_user = user
    end
    
    def logged_in?
      !current_user.nil?
    end
    
    def store_location
      session[:return_to] = request.request_uri
    end
    
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
end
