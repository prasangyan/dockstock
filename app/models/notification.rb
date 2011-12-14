class Notification < ActiveRecord::Base
  validates_presence_of :email , :message => "Please input email."
  validates_format_of :email, :with => %r{^(?:[_a-z0-9-]+)(\.[_a-z0-9-]+)*@([a-z0-9-]+)(\.[a-zA-Z0-9\-\.]>> +)*(\.[a-z]{2,4})|(\.[a-z]{2,4})$}i , :message => "Please input valid email id"
  validates_uniqueness_of :email, :message =>  "This email id is already registered."
end
