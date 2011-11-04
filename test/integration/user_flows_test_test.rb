require 'test_helper'

class UserFlowsTestTest < ActionDispatch::IntegrationTest
  fixtures :all

  # Replace this with your real tests.
  test "the login/default page" do

    # removing all the users
    Authentication.all.each do |auth|
      auth.destroy
    end

    # testing whether the site is opened the login page
    get "/"
    assert_response :success

    # testing if we pass invalid username and password
    post "/", :username => "santhoshonet@gmail.com", :password => "password"
    assert_response :success
    assert assigns(@error)


    #testing if we pass nil values
    post "/", :username => nil, :password => "some password"
    assert_response :success
    assert assigns(@error)


    post "/", :username => nil, :password => nil
    assert_response :success
    assert assigns(@error)


    post "/", :username => "some username", :password => nil
    assert_response :success
    assert assigns(@errror)


    # creating an user manually
    authentication = Authentication.new
    authentication.username = "santhoshonet@gmail.com"
    authentication.password = "password"
    authentication.save

    # now we can try with values

    # passing only username, checking whether its checking password
    post "/", :username => "santhoshonet@gmail.com" , :password => "an invalid password"
    assert_response :success
    assert assigns(@error)


    post "/", :username => "santhoshonet@gmail.com", :password => nil
    assert_response :success
    assert assigns(@error)


    #validating the password case sensitive
    post "/", :username => "santhoshonet@gmail.com", :password => "PAssword"
    assert_response :success
    assert assigns (@error)


    # now passing the actual values
    post "/", :username => "santhoshonet@gmail.com", :password => "password"
    #assert_redirected_to clients_url
    assert_response :success
    assert_nil(@error)

   true

  end


  test"the register page" do

  end


end
