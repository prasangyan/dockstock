require "test_helper"
class AuthenticationsControllerTest < ActionController::TestCase

  setup do
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create authentication" do
    # with invalid username and password
    authentication = authentications(:one)
    post :create, :authentication => authentication.attributes
    assert_response :success

    # with proper username and password
    authentication = authentications(:two)


    record = Authentication.new
    record.username = authentication[:username]
    record.password = authentication[:password]
    record.save

    post :create, :authentication => authentication.attributes
    assert_response :success

    #wtih empty password
    authentication = authentications(:three)
    post :create, :authentication => authentication.attributes
     assert_response :success


    #with empty username and password
    authentication = authentications(:four)
    post :create , :authentication => authentication.attributes
    assert_response :success


    #with nil username and password
    authentication = authentications(:four)
    post :create , :authentication => authentication.attributes
    assert_response :success

    # and finally
    # with proper username and password
    authentication = authentications(:two)


    record = Authentication.new
    record.username = authentication[:username]
    record.password = authentication[:password]
    record.save

    post :create, :authentication => authentication.attributes
    assert_response :success

  end

  test "should get register" do
    get :register
    assert_response :success
  end

  test "should get createuser" do
    authentication = authentications(:one)
    post :create, :authentication => authentication.attributes
    assert_response :success
  end

end
