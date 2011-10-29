class S3Object < ActiveRecord::Base
  validates_presence_of :key
  validates_uniqueness_of :key
end
