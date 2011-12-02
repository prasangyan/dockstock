class ObjectChangeHistory < ActiveRecord::Base
  belongs_to :s3_object
  belongs_to :s3_object_version
  belongs_to :machine
end
