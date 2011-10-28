class ApplicationController < ActionController::Base
  protect_from_forgery
  protected
  def isuserloggedin
    if ENV['RAILS_ENV'] != 'test'
      if session[:currentuser].nil?
        redirect_to :controller => "authentications", :action => "new"
      else
        if Authentication.find_by_id(session[:currentuser]).nil?
          redirect_to :controller => "authentications", :action => "new"
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
