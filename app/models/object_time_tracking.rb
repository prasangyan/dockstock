class ObjectTimeTracking < ActiveRecord::Base
  belongs_to :s3_object
  belongs_to :machine
  validates_presence_of :last_modified
end
