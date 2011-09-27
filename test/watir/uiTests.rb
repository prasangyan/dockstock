require 'watir-webdriver'

# If you want to use chrome as the browser, uncomment the following. Chromium needs to be avilable in a folder in the system path.
#browser = Watir::Browser.new :chrome
browser = Watir::Browser.new 
browser.goto 'file:///D:/Work/Design/docstock/dashboard.htm'
inputLoadTime = browser.text_field(:id => 'searchInput').set 'hello'
puts "Load time: #{inputLoadTime} "

