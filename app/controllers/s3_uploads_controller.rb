require 'base64'
class S3UploadsController < ApplicationController
                              before_filter :isuserloggedin
  # You might want to look at https and expiration_date below.
  #        Possibly these should also be configurable from S3Config...
  skip_before_filter :verify_authenticity_token
  include S3SwfUpload::Signature
  def index
    bucket          = S3SwfUpload::S3Config.bucket
    access_key_id   = S3SwfUpload::S3Config.access_key_id
    acl             = S3SwfUpload::S3Config.acl
    secret_key      = S3SwfUpload::S3Config.secret_access_key
    key             = params[:key]
    content_type    = params[:content_type]
    https           = 'false'
    error_message   = ''
    expiration_date = 1.hours.from_now.utc.strftime('%Y-%m-%dT%H:%M:%S.000Z')
    policy = Base64.encode64(
"{
    'expiration': '#{expiration_date}',
    'conditions': [
        {'bucket': '#{bucket}'},
        {'key': '#{key}'},
        {'acl': '#{acl}'},
        {'Content-Type': '#{content_type}'},
        {'Content-Disposition': 'attachment'},
        ['starts-with', '$Filename', ''],
        ['eq', '$success_action_status', '201']
    ]
}").gsub(/\n|\r/, '')

    #signature = b64_hmac_sha1(secret_key, policy)
    signature = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha1'), secret_key, policy)).gsub("\n","")
    respond_to do |format|
      format.xml {
        render :xml => {
          :policy          => policy,
          :signature       => signature,
          :bucket          => bucket,
          :accesskeyid     => access_key_id,
          :acl             => acl,
          :expirationdate  => expiration_date,
          :https           => https,
          :errorMessage    => error_message.to_s
        }.to_xml
      }
    end

    categoryname = "userstories"
    category = Category.find_by_name(categoryname)
    if category.nil?
      category = Category.new
      category.name = categoryname
      category.save
    end
    project = Project.find_by_name(session[:project_name])
    document = Document.find_by_name(key)
    if document.nil?
      document = Document.new
      document.project = project
      document.project_id = project.id
      document.category = category
      document.category_id = category.id
      document.authentication = Authentication.find_by_id(session[:currentuser])
      document.authentication_id = session[:currentuser]
      document.name = key
      if document.save
        document.addhistory_new(session[:currentuser])
      else
        puts document.errors.full_messages
      end
    else
      document.addhistory_version(session[:currentuser])
    end

  end
end
