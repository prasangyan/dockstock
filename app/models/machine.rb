class Machine < ActiveRecord::Base
  belongs_to :authentication
  has_many :object_time_trackings
  has_many :object_change_histories
end
