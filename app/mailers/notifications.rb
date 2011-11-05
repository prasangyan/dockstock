class Notifications < ActionMailer::Base
  def forgot_password(user,resetcode)
    setup_email(user, "Reset your password")
    @resetcode = resetcode
  end
  def invitation(email)
    setup_invitation_email(email, "Welcome to Versa Vault")
  end
  def signup(user)
    setup_email(user,"Welcome to Versa Vault")
  end
  protected
  def setup_email(user,subject)
    @recipients = "#{user.username}"
    @from = ENV["mail_username"]
    @sent_on = Time.now
    @body[:user] = user
    @subject = subject
    @name = user.name
    @content_type = "text/html"
  end
  def setup_invitation_email(email,subject)
    @recipients = email
    @name = email
    @from = ENV["mail_username"]
    @sent_on = Time.now
    @subject = subject
    @content_type = "text/html"
  end
end
