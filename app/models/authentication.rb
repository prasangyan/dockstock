require 'digest/sha1'

class Authentication < ActiveRecord::Base

  belongs_to :history
  has_many :documents
  has_many :comments

  validates_length_of :password, :within => 5..40 , :message => "Password length is too short!"

  validates_format_of :username, :with => %r{^(?:[_a-z0-9-]+)(\.[_a-z0-9-]+)*@([a-z0-9-]+)(\.[a-zA-Z0-9\-\.]>> +)*(\.[a-z]{2,4})$}i

  validates_uniqueness_of :username , :message => "this email-id already registered! Try forgot password."

  validates_presence_of :username , :password, :password_salt


  attr_protected :id, :salt

  attr_accessor :password

  def authenticate(username, pass)
    u= Authentication.find(:first, :conditions=>["username = ?", username])
    return nil if u.nil?
    return u if Authentication.encrypt(pass, u.password_salt)==u.crypted_password
    nil
  end


  def self.authenticate(username, pass)
    u= Authentication.find(:first, :conditions=>["username = ?", username])
    return nil if u.nil?
    return u if Authentication.encrypt(pass, u.password_salt)==u.crypted_password
    nil
  end

  def password=(pass)
    @password=pass
    self.password_salt = Authentication.random_string(10) if !self.password_salt?
    self.crypted_password = Authentication.encrypt(@password, self.password_salt)
  end

  def send_reset_password
    reset_code = Authentication.random_string(10)
    self.reset_code = reset_code
    self.save
    Notifications.deliver_forgot_password(self, reset_code)
  end

  protected

  def self.encrypt(pass, salt)
    Digest::SHA1.hexdigest(pass+salt)
  end

  def self.random_string(len)
    #generat a random password consisting of strings and digits
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end


end
