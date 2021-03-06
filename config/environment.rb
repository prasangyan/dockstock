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
ENV["WEBSOLR_URL"] = YAML.load_file("#{RAILS_ROOT}/config/web_solr.yml")[RAILS_ENV]["websolr_url"]
AMAZON_CONFIG = YAML.load_file("#{RAILS_ROOT}/config/amazon_s3.yml")[RAILS_ENV]
