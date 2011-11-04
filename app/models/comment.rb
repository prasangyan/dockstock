class Comment < ActiveRecord::Base
    belongs_to :document
    belongs_to :authentication
    validates_presence_of :comment, :authentication_id, :document_id

end
