class S3ObjectVersion < ActiveRecord::Base
  belongs_to :s3_object
  has_one :object_change_history
end
