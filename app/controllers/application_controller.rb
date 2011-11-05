class ApplicationController < ActionController::Base
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
end
