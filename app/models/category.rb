class Category < ActiveRecord::Base
        has_many :documents
  validates_presence_of :name
  validates_uniqueness_of :name
end


