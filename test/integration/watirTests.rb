# Todo: Put a success page after the registration page
# Todo: Change the hover state of the close button in the invite page
# Todo: Change the hover state of the close button in the invite page for emails
# Todo: Why is syncmetadata-amazon downloading?

require 'watir-webdriver'
require 'colorize'

############################################################################
# Functions
############################################################################
def results(browser,test_case,testResult,successMessage,failureMessage)
  if testResult == true
    puts '[PASS]'.green + successMessage
  else
    puts '[FAIL]'.red + failureMessage
    screenshot = "./screenshots/FAILED_#{test_case.gsub(' ','_').gsub(/[^0-9A-Za-z_]/, '')}.png"
    browser.driver.save_screenshot(screenshot)
  end
end
############################################################################

browser = Watir::Browser.new

site = "versavault.com"
testEmail = "prashant@blendit.com.my"
testEmailPassword = "password@123"
signUpURL = "http://versavault.com/register"
name = "Prashant Angyan"
loginEmailIdField = "emailid"
browser.goto site

############################################################################
test_case = 'TEST-CASE:Check if the login page loads properly and contains all the right fields, links and buttons'
puts test_case
############################################################################

testResult = browser.text_field(:id => "emailid").exists?
results(browser,test_case,testResult,' Email field is available on the login page',' Email field is not available on the login page')

testResult = browser.text_field(:id => "password").exists?
results(browser,test_case,testResult,'Password field is available on the login page','Password field is not available on the login page')

testResult = browser.link(:id => "BtnLogIn").exists?
results(browser,test_case,testResult,'Login button is available on the login page','Login button is not available on
the login page')

############################################################################
test_case = 'TEST-CASE:Registration page exists and fields exist'
puts test_case
############################################################################
if browser.link(:href,"/register").exists?
  puts '[PASS]'.green + 'Sign up links is available on the login page'
else
  puts '[FAIL]'.red + 'Sign up links is not available on the login page'
end

browser.link(:href,"/register").click
if browser.url == signUpURL
  puts '[PASS]'.green + 'Sign up links works and page goes to the registration page'
else
  puts '[FAIL]'.red + 'Sign up links does not work and goes to:'+browser.url
end

if browser.text_field(:id,"emailid").exists?
  puts '[PASS]'.green + 'Email text field is available in the Sign Up page'
else
  puts '[FAIL]'.red + 'Email text is field not available in the Sign Up page'
end

if browser.text_field(:id,"password").exists?
  puts '[PASS]'.green + 'Password text is available in the Sign Up page'
else
  puts '[FAIL]'.red + 'Password text is not available in the Sign Up page'
end

if browser.text_field(:id,"confirm_password").exists?
  puts '[PASS]'.green + 'Password text is available in the Sign Up page'
else
  puts '[FAIL]'.red + 'Password text is not available in the Sign Up page'
end

if browser.link(:id,"BtnSignUp").exists?
  puts '[PASS]'.green + 'Sign Up button is available in the Sign Up page'
else
  puts '[FAIL]'.red + 'Sign Up button is not available in the Sign Up page'
end
############################################################################

############################################################################
test_case = 'TEST-CASE:Registration submission'
puts test_case
############################################################################
messageToShowAfterRegistration = '<h2>You are all set, <name>. Thanks!</h2>
<p>You can start uploading files easily. Just download the <a href="<download link>">Versa Vault Desktop Client</a>
and you can start storing and sharing documents. We also sent you an email with all the details on how to get back here</p>'

browser.text_field(:id => "name").set name
browser.text_field(:id => "emailid").set testEmail
browser.text_field(:id => "password").set testEmailPassword
browser.text_field(:id => "confirm_password").set testEmailPassword
browser.link(:id,"BtnSignUp").click

testResult = browser.url == "http://versavault.com/dashboard"
results(browser,test_case,testResult,'Post registration was successful. The page redirects to the dashboard page',
        "Post registration was unsuccessful. The page does not redirect to the dashboard page")

testResult = browser.html.include? messageToShowAfterRegistration
results(browser,test_case,testResult,'Post registration was successful. The right message was shown',
        "Post registration was unsuccessful. The message shown is wrong. It should be:
#{messageToShowAfterRegistration}")

puts "I am not checking if a email is sent as soon as registration is completed. So you will have to manually check
if the email is sent for now".red

############################################################################
test_case = 'TEST-CASE:Forgot password test'
puts test_case
############################################################################
# Todo: Fix this in case the registration is successful then things will break. Need to log the user out first
browser.goto site

testResult = browser.link(:href,"/forgotpassword").exists?
results(browser,test_case,testResult,'Forgot password link is available on the login page',
        "Forgot password link is not available on the login page")

browser.link(:href,"/forgotpassword").click
testResult = browser.url == "http://versavault.com/forgotpassword"
results(browser,test_case,testResult,'Forgot password link works correctly',
        "Forgot password link is not working. It is redirecting to the wrong page")

browser.text_field(:id => "emailid").set testEmail
browser.link(:id => "BtnResetPassword").click
testResult = browser.url == "#{site}/login"
results(browser,test_case,testResult,'Page redirects to the login page once the email is entered in the forgot
password page',"Page does not redirect to the login page once the email is entered in the forgot password page")

messageToShowWhenPasswordResetLinkSent = "Instructions for signing in have been emailed to you"
testResult = browser.text.include? messageToShowWhenPasswordResetLinkSent
results(browser,test_case,testResult,'Page contains a message telling the user that the password reset information
has been sent to his inbox',"Page does not contain a message telling the user that the password reset information
has been sent to his inbox. Message should be:#{messageToShowWhenPasswordResetLinkSent}")

# Todo: Add a test to see what happens when the link is clicked multiple times

############################################################################
test_case = 'TEST-CASE:Error message check'
puts test_case
############################################################################

browser.goto site
puts "Testing invalid entries in the text boxes"

messageToShowOnInvalidEntry = "Opp! Looks like you entered an invalid email address or password. Please try again"

browser.text_field(:id => "emailid").set "abc"
browser.link(:id => 'BtnLogIn').click
testResult = browser.text.include? messageToShowOnInvalidEntry
results(browser,test_case,testResult,"The right error message was shown when an invalid email address was entered in
the login page","Something wrong with the error message shown when an invalid email address is entered in the email
text field. The message should be:#{messageToShowOnInvalidEntry}")


############################################################################
test_case = 'TEST-CASE:Login test'
puts test_case
############################################################################
browser.goto site
browser.text_field(:id,"emailid").set testEmail
browser.text_field(:id,"password").set testEmailPassword
browser.link(:id,"BtnLogIn").click

testResult = browser.url == "http://versavault.com/dashboard"
results(browser,test_case,testResult,'Login successful. The page redirects to the dashboard page',
        "Login was unsuccessful. The page does not redirect to the dashboard page")



