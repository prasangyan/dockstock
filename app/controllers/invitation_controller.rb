class InvitationController < ApplicationController
  def send(search,emailInvite)

    unless params[:emailInvite].nil?
      params[:emailInvite].to_s.split(';').each do |mail|
        auth = Authentication.find_by_username(mail)
        if auth.nil?
          Notifications.invitation(mail).deliver
          user = Authentication.new
          user.username = mail
          user.name = mail
          random_password = Authentication.random_string(10)
          user.password = random_password
          user.password_confirmation = random_password
          if user.save
            user.send_reset_password
            define_shared_object(user)
          end
        else
          define_shared_object(auth)
        end
      end
      render :text => true
    else
      render :text => false
    end

  end

  private

  def define_shared_object(auth)
    folder = params[:folder]
    parent_uid = params[:parent_uid]
    if folder.to_s == "true"
      if parent_uid.to_s == "0"
        # he is sharing dashboard main page, so all the objects need to share
        shared_object = SharedS3Objects.find_by_root_folder_and_authentication_id(true,auth.id)
        if shared_object.nil?
          new_shared_object = SharedS3Objects.new
          new_shared_object.root_folder = true
          new_shared_object.authentication_id = auth.id
          new_shared_object.save
        end
      end
      return
    end
    s3_object = S3Object.find_by_id(params[:object_id])
    unless s3_object.nil?
      shared_object = SharedS3Objects.find_by_s3_object_id_and_authentication_id(s3_object.id,auth.id)
      if shared_object.nil?
        new_shared_object = SharedS3Objects.new
        new_shared_object.root_folder = false
        new_shared_object.authentication_id = auth.id
        new_shared_object.s3_object_id = s3_object.id
        new_shared_object.save
      end
    end
  end

end
