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
      @error = "Invalid email or password entered!"
      @authentication = Authentication.new
      @authentication.username = params[:username]
      render :new
  end

  def register
    @authentication = Authentication.new
  end

  def createuser
    @error = nil
    unless params[:name].nil? && params[:username] && params[:password].nil?
      newuser = Authentication.new
      newuser.name = params[:name]
      newuser.username = params[:username]
      newuser.password = params[:password]
      if params[:password] == params[:confirm_password]
        if newuser.save
          newuser.bucketKey = ''
          begin
            newuser.bucketKey = newuser.name + "-"  + Time.now.strftime("%y%m%d%H%M%S").to_s
            AWS::S3::Bucket.create(newuser.bucketKey,:access => :public_read)
            bucket = AWS::S3::Bucket.find(newuser.bucketKey)
            unless bucket.nil?
              newuser.save
            end
          end
          session[:currentuser] = newuser.authenticate(params[:username],params[:password]).id
          @status = "Your account has been registered successfully. <br /> Click <a href='/dashboard' > here </a> to view your VersaVault."
          Notifications.signup(newuser).deliver
          render :success
          #redirecttohome
          return
        else
          newuser.errors.each do |attr,msg|
            @error = msg + "<br />"
          end
        end
      else
        @error = "Confirmation password not matched!"
      end
    else
      @error = "Ooops, Unable to register your account due to invalid inputs found."
    end
    @authentication = Authentication.new
    @authentication.username = params[:username]
    @authentication.name = params[:name]
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
        @status = "An email has been send to you for resetting your dockstock password. <br /> Click <a href='/login' > here </a> to login dockstock."
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
        user = Authentication.find(:first, :conditions => "reset_code = '#{params[:reset_code]}'")
        unless user.nil?
          user.password = params[:password]
          user.save
          @status = "Password changed successfully. <br /> Click <a href='/login' > here </a> to login dockstock."
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

  #methods for sync tool

  def getamazonbucketid
    unless params[:username].nil? && params[:password].nil?
      result = Authentication.authenticate(params[:username].to_s,params[:password].to_s)
      unless result.nil?
        render :json => {:bucket_id => result.bucketKey}
      else
        render :json => {:error => "Invalid username or password"}
      end
    else
      render :json => {:error => "Invalid parameters password"}
    end
  end

end
