class SharedS3Objects < ActiveRecord::Base
  belongs_to :s3_object
  belongs_to :authentication
end
