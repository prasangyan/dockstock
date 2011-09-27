require 'rubygems'
require 'aws/s3'

AWS::S3::Base.establish_connection!(
	:access_key_id => 'AKIAJ4B23ECLFYK7PUGQ',
	:secret_access_key => 'NSokb89DPuBSqSi0ca4k/0X5RHmxvE6ELCq5VbVN'
)

# file = ARGV.first
bucket = "StarTrek"

location = 'D:\Work\Design\docstock\sampleData'

# puts file
Dir.entries(location).each do |file|
	completePath = location  + "/" + file
  if file == '.' || file == '..'
    puts 'Not a valid file name:' + completePath
  else
    puts 'Writing ' + file + ' to Amazon'
    AWS::S3::S3Object.store(File.basename(completePath),open(completePath),bucket,:access => :public_read)
	  puts AWS::S3::S3Object.url_for(File.basename(completePath), bucket)[/[^?]+/]
  end
end

