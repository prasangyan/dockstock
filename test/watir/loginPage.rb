require "watir-webdriver"

browser = Watir::Browser.new
# Need to figure out a way to make this path relative
url = "file:///D:/Work/Design/docstock/login.htm"
browser.goto url
# Testing the email field in the login form
# This test assumes the button is a link and not a normal button
def checkInvalidEmailAddresses(url,emailFieldId,buttonToClick,browser)
  invalidEmailAddresses = ["hdfjs","this is a mail with spaces@yahoo.com", "just a Word", "_sdn@nfdk.com"]
  wrongEmailAddressesThatAreGettingThrough = Array.new
  # Testing invalid email addresses
  invalidEmailAddresses.each do |invalidEmail|
    browser.goto url
    browser.text_field(:id => emailFieldId).set invalidEmail
    browser.link(:id => buttonToClick).click
    testStatus = browser.text.include? 'Looks like your email id or password is invalid.'
    if testStatus == false
      wrongEmailAddressesThatAreGettingThrough.push(invalidEmail)
    end
  end
  return wrongEmailAddressesThatAreGettingThrough
end

def checkValidEmailAddresses (url,emailFieldId,buttonToClick,browser)
  validEmailAddresses  = ["hdh@yahoo.com", "2323@yahoo.com", "hdjk@com.my", "hdsjd.ahdjs@yahoo.com"]
  rightEmailAddressesThatAreNotGettingThrough = Array.new
  # Testing valid email addresses. Should not return an error on page
  validEmailAddresses.each do |validEmail|
    browser.goto url
    browser.text_field(:id => emailFieldId).set validEmail
    browser.link(:id => buttonToClick).click
    testStatus = browser.text.include? 'Looks like your email id or password is invalid.'
    if testStatus == true
      rightEmailAddressesThatAreNotGettingThrough.push(validEmail)
    end
  end
  return rightEmailAddressesThatAreNotGettingThrough
end

# Testing the password field in the login page
def emptyPasswordField(url,passwordFieldId,browser,buttonToClick)
  browser.text_field(:id => "password").set ""

end

# Checking possible invalid output. All these values should return an error
# Testing invalid email addresses. Should return and error on page


puts "Completed testing the valid data"

wrongEmailIdsAllowed = checkInvalidEmailAddresses(url,"emailId","loginButton", browser)
if wrongEmailIdsAllowed.empty?
  puts "Everything looks good"
else
  puts "Error!"
  puts "List of invalid email ids allowed:#{wrongEmailIdsAllowed}"
end

rightEmailsNotAllowedThrough = checkValidEmailAddresses(url,"emailId","loginButton", browser)
if rightEmailsNotAllowedThrough.empty?
  puts "Valid Emails:Everything looks good"
else
  puts "Error!"
  puts "List of valid email ids not allowed:#{rightEmailsNotAllowedThrough}"
end
browser.close