class S3Object < ActiveRecord::Base
  belongs_to :authentication
  validates_presence_of :key
  #validates_uniqueness_of :url
  validate :validate_record
  private
  def validate_record
    unless S3Object.find_by_authentication_id_and_key(self.authentication_id,self.key).nil?
      errors.add_to_bas "duplicate record"
    end
  end
end
