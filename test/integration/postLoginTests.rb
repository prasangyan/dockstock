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
dashboardPage = "http://versavault.com/dashboard"
loginEmailIdField = "emailid"
browser.goto site

############################################################################
test_case = 'Testing if logged in. Otherwise logging in'
puts test_case
############################################################################

if browser.url == dashboardPage
  puts "Already logged in. Continuing with the tests"
else
  browser.text_field(:id => 'emailid').set testEmail
  browser.text_field(:id => 'password').set testEmailPassword
  browser.link(:id => 'BtnLogIn').click
  testResult = browser.url == dashboardPage
  results(browser, test_case, testResult, 'Logged in properly. Continuing with the loged in tests',
          'Something went wrong with the login.')
end


############################################################################
test_case = 'TEST-CASE:Dashboard test'
puts test_case
############################################################################

metaDataTextThatShouldNotBeVisible1 = "syncmetadata-amazon"
metaDataTextThatShouldNotBeVisible2 = "syncreplicaid-amazon"

# Todo: Find out how to do a not for includes
testResult = browser.text.include? metaDataTextThatShouldNotBeVisible1 || browser.text.include?
metaDataTextThatShouldNotBeVisible2
results(browser, test_case, testResult, 'None of the Amazon metadata files are shown',
        'Amazon meta data files are shown.')

puts not browser.text.include? metaDataTextThatShouldNotBeVisible1