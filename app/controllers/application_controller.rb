class ApplicationController < ActionController::Base
  filter_parameter_logging :password
  protect_from_forgery
  protected
  def isuserloggedin
    if ENV['RAILS_ENV'] != 'test'
      if session[:currentuser].nil?
        redirect_to login_url
      else
        authentication = Authentication.find_by_id(session[:currentuser])
        if authentication.nil?
          redirect_to login_url
          return false
        else
          return true
        end
      end
      false
    else
        true
    end
  end

  def current_user_session
    return @current_user_session if defined? (@current_user_session)
    @current_user_session =  UserSession.find
  end

  def current_user
    return @current_user if defined? (@current_user)
    @current_user = current_user_session && @current_user_session.record
  end

end
