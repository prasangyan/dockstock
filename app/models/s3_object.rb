require "open-uri"
class S3Object < ActiveRecord::Base
  belongs_to :authentication
  validates_presence_of :key
  #validates_uniqueness_of :url
  validate :validate_record , :on => :create
  after_save :push_content_to_websolr
  private
  def validate_record
    unless S3Object.find_by_authentication_id_and_key(self.authentication_id,self.key).nil?
      errors.add_to_base "duplicate record"
    end
  end
  def push_content_to_websolr
    if self.folder == false
      begin
        if File.extname(self.fileName).to_s().downcase == ".pdf"
            rsolr = RSolr.connect :url => ENV["WEBSOLR_URL"]
            io = open(self.url.to_s)
            reader = PDF::Reader.new(io)
            unless reader.nil?
              pdf_content = ''
              reader.pages.each do |page|
                unless page.text.nil?
                  pdf_content += page.text
                end
              end
              rsolr.add(:id => self.id, :text => pdf_content )
              rsolr.commit
            end
        end
      rescue => ex
        puts ex.message
      end
    end
  end
end
