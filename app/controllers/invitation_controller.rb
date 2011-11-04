class InvitationController < ApplicationController
  def send(search,emailInvite)
    unless params[:emailInvite].nil?
      params[:emailInvite].to_s.split(';').each do |mail|
        Notifications.invitation(mail).deliver
      end
      render :text => true
    else
      render :text => false
    end
  end
end
