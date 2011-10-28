class Notifications < ActionMailer::Base
  def forgot_password(user,resetcode)
    setup_email(user, "reset your password")
    @resetcode = resetcode
  end

  protected
  def setup_email(user,subject)
    @recipients = "#{user.username}"
    @from = ENV["mail_username"]
    @sent_on = Time.now
    @body[:user] = user
    @subject = subject
    @name = user.username
    @content_type = "text/html"
  end
end
