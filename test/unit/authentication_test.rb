require "test_helper"
class AuthenticationTest < ActiveSupport::TestCase

  # Replace this with your real tests.
  test "the truth" do


    # validating nil types
    authentication = Authentication.new
    authentication.username = nil
    authentication.password = nil
    authentication.save

    assert_not_nil(authentication.errors)
    assert(authentication.errors.count() > 0 , "Nil values accepting")
    assert(authentication.errors.full_messages.count() > 0,"Nil values accepting" )

    assert(authentication.errors.invalid?(:username))
    assert(authentication.errors.invalid?(:password))




    #validating nil password
    authentication.username = "santhosh"
    authentication.password = nil
    authentication.save

    assert_not_nil(authentication.errors)
    assert(authentication.errors.count() > 0 , "Nil password accepting")
    assert(authentication.errors.full_messages.count() > 0,"Nil password accepting" )

    assert(authentication.errors.invalid?(:username))
    assert(authentication.errors.invalid?(:password))


    #validating nil username
    authentication.password = "password"
    authentication.username = nil
    authentication.save

    assert_not_nil(authentication.errors)
    assert(authentication.errors.count() > 0 , "Nil username accepting")
    assert(authentication.errors.full_messages.count() > 0,"Nil username accepting" )

    assert(authentication.errors.invalid?(:username))



    #invalid username format [not in email format]
    authentication.username = "santhoshonet"
    authentication.password = "password"
    authentication.save

    assert_not_nil(authentication.errors)
    assert(authentication.errors.count() > 0 , "Invalid email format accepting")
    assert(authentication.errors.full_messages.count() > 0,"Invalid Email format accepting" )

    assert(authentication.errors.invalid?(:username))


    #valid username and password
    authentication.username = "santhoshonet@ymail.com"
    authentication.password = "password@123"
    authentication.save

    assert(authentication.errors.count() == 0, "Not saving the proper credentials." )
    assert_not_nil(authentication.id)



    #checking the uniqueness of the username
    authentication = Authentication.new
    authentication.username = "santhoshonet@ymail.com"
    authentication.password = "anotherpassword"
    authentication.save

    assert_not_nil(authentication.errors)
    assert(authentication.errors.count() > 0 , "Accepted repeated username.")
    assert(authentication.errors.full_messages.count() > 0,"Accepted repeated username." )

  end
end
