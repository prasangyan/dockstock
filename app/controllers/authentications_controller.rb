class AuthenticationsController < ApplicationController
  # GET /authentications/new
  # GET /authentications/new.xml
  def new
    @error = nil
    @authentication = Authentication.new
    #if Authentication.find(:all).length > 0
    #  session[:currentuser] = Authentication.find(:first).id
    #  redirecttohome
    #  return
    #end
  end

  def logout
    session[:currentuser] = nil
    redirect_to login_url
  end

  # POST /authentications
  # POST /authentications.xml
  def create
    @error = nil
    auth = Authentication.authenticate(params[:username], params[:password])
    unless auth.nil?
      session[:currentuser] = auth.id
      redirecttohome
      return
    end
      @error = "Invalid username or password entered!"
      @authentication = Authentication.new
      @authentication.username = params[:username]
      render :new
  end

  def register
    @authentication = Authentication.new
  end

  def createuser
    @error = nil
    newuser = Authentication.new
    newuser.username = params[:username]
    newuser.password = params[:password]
    if params[:password] == params[:confirm_password]
      if newuser.save
        session[:currentuser] = newuser.authenticate(params[:username],params[:password]).id
        redirecttohome
        return
      else
        @error = newuser.errors.full_messages
      end
    else
      @error = "Confirmation password not matched!"
    end
    @authentication = Authentication.new
    @authentication.username = params[:username]
    render :register
  end

  def redirecttohome
    redirect_to dashboard_url
    #redirect_to :controller => "dashboard", :action => "index"
  end

  def forgotpassword
    unless params[:username].nil?
      user = Authentication.find(:first, :conditions => "username = '#{params[:username]}'")
      unless user.nil?
        user.send_reset_password
        @status = "An email has been send to you for resetting your dockstock password."
        render :success
      else
          @error = 'Invalid email address entered!'
      end
    end
  end

  def success
  end

  def resetpassword
    @user = nil
    unless params[:id].nil?
      puts "the reset key is " + params[:id].to_s
      user = Authentication.find(:first, :conditions => "reset_code = '#{params[:id]}'")
      unless user.nil?
        @user = user
      else
          @status = "Invalid reset password key found."
          render :success
      end
    else
      @status = "Invalid reset password key found."
      render :success
    end
  end

  def setpassword
    unless params[:password].nil? and params[:confirm_password].nil? and params[:reset_code].nil?
      if params[:password] == params[:confirm_password]
        user = Authentication.find(:first, :conditions => "reset_code = '#{params[:id]}'")
        unless user.nil?
          user.password = params[:password]
          user.save
          @status = "Password changed successfully."
          render :success
        else
          @status = "Invalid parameters passed."
          render :success
        end
      else
          @status = "Invalid parameters passed."
          render :success
      end
    else
        @status = "Invalid parameters passed."
        render :success
    end
  end
end
