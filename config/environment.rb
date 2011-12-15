# Load the rails application
require File.expand_path('../application', __FILE__)
# Initialize the rails application
S3FileManager::Application.initialize!
ENV["mail_username"] = "notifications@versavault.com"
ActionMailer::Base.smtp_settings = {
        :enable_starttls_auto => true,
        :address => "smtp.gmail.com",
        :port => "587",
        :user_name => ENV["mail_username"],
        :password => "password@123",
        :authentication => :plain,
        :smtp => true,
        :content_type => "text/html"
        }
ActionMailer::Base.delivery_method = :smtp
ENV["WEBSOLR_URL"] = "http://index.websolr.com/solr/b840ba32a68"

