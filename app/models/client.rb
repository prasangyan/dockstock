class Client < ActiveRecord::Base
    has_many :projects
    validates_presence_of :name
    validates_uniqueness_of :name
end
