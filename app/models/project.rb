class Project < ActiveRecord::Base
    belongs_to :client
    has_many :documents
    validates_presence_of :name , :message => "please input project name"
    validates_uniqueness_of :name, :message => "the project name you entered is already exists."
end
