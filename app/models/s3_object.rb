class S3Object < ActiveRecord::Base
  belongs_to :authentication
  validates_presence_of :key
  validates_uniqueness_of :key
end
