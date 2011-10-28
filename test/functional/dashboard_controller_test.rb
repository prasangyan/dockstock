require 'test_helper'

class DashboardControllerTest < ActionController::TestCase

  test "should get index" do

    # running before log-in
    get :index
    #assert_redirected_to :controller => "authentications", :action => "new"
    assert_response :success
    # authenticating with actual values
    # creating an user first
    username = "santhoshonet@gmail.com"
    password = "password@123"
    user = Authentication.new
    user.username = username
    user.password = password
    user.save

    oldcontroller = @controller
    @controller = AuthenticationsController.new
    post :create, :authentication => {:username => username, :password => password}
    assert_response :success

    @controller = oldcontroller
    # now we will check the dashboard
    get :index
    #assert_redirected_to :controller => "authentications", :action => "new"
    assert_response :success

  end

end
