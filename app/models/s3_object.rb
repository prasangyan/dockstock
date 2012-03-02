require "open-uri"
require "rubygems"
require "roo"
class S3Object < ActiveRecord::Base
  belongs_to :authentication
  has_many :shared_s3_objectses
  has_many :object_time_trackings
  has_many :s3_object_versions
  has_many :object_change_histories
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
        file_extention = File.extname(self.fileName).to_s().downcase
        if file_extention == ".pdf"
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
            #puts pdf_content
            rsolr.add(:id => self.id, :pdf_texts => pdf_content )
            rsolr.commit
          end
        elsif file_extention == ".txt" or file_extention == ".csv" or file_extention == ".html" or file_extention == ".htm" or file_extention == ".csv" or file_extention == ".xml" or file_extention == ".xml" or file_extention == ".xhtml" or file_extention == ".xps" or file_extention == ".tiff" or file_extention == ".php" or file_extention == ".aspx" or file_extention == ".asp" or file_extention == ".c" or file_extention == ".h" or file_extention == ".cpp" or file_extention == ".vb" or file_extention == ".bat"
          rsolr = RSolr.connect :url => ENV["WEBSOLR_URL"]
          io = open(self.url.to_s)
          content = io.read
          rsolr.add(:id => self.id, :pdf_texts => content )
          rsolr.commit
        elsif file_extention == ".xlsx"
          io = open(self.url.to_s)
          directory = File.join(Rails.root,"public")
          path = File.join(directory,self.fileName)
          File.open(path, "wb") { |f| f.write(io.readlines()) }
          oo = Excelx.new(path)
          oo.default_sheet = oo.sheets.first
          content = ''
          1.upto(oo.last_column).each do |line|
            1.upto(oo.last_row).each do |row|
              content += " " + oo.cell(line,row).to_s
            end
          end
          #puts content
          rsolr.add(:id => self.id, :pdf_texts => content )
          rsolr.commit
          File.delete(path)
        elsif file_extention == ".xls"
          io = open(self.url.to_s)
          directory = File.join(Rails.root,"public")
          path = File.join(directory,self.fileName)
          File.open(path, "wb") { |f| f.write(io.readlines()) }
          oo = Excel.new(path)
          oo.default_sheet = oo.sheets.first
          content = ''
          1.upto(oo.last_column).each do |line|
            1.upto(oo.last_row).each do |row|
              content += " " + oo.cell(line,row).to_s
            end
          end
          puts content
          rsolr.add(:id => self.id, :pdf_texts => content )
          rsolr.commit
          File.delete(path)
        elsif file_extention == ".ods"    # open office files
           io = open(self.url.to_s)
          directory = File.join(Rails.root,"public")
          path = File.join(directory,self.fileName)
          File.open(path, "wb") { |f| f.write(io.readlines()) }
          oo = Openoffice.new(path)
          oo.default_sheet = oo.sheets.first
          content = ''
          1.upto(oo.last_column).each do |line|
            1.upto(oo.last_row).each do |row|
              content += " " + oo.cell(line,row).to_s
            end
          end
          puts content
          rsolr.add(:id => self.id, :pdf_texts => content )
          rsolr.commit
          File.delete(path)
        end
      rescue => ex
        puts ex.message
      end
    end
  end
end
