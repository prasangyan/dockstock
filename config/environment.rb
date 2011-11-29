# Load the rails application
require File.expand_path('../application', __FILE__)
# Initialize the rails application
S3FileManager::Application.initialize!
 #AWS::S3::Base.establish_connection!(
 #     :access_key_id => "AKIAIW36YM46YELZCT3A",
 #     :secret_access_key => "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"
 #)
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

