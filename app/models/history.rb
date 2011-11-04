class History < ActiveRecord::Base
    has_one :authentication
    belongs_to :document
    validates_presence_of :document_id, :authentication
end
