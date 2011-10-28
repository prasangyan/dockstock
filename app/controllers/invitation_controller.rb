class InvitationController < ApplicationController
  def send
    unless params[:emailInvite].nil?
      Notifications.invitation(params[:emailInvite].to_s)
      render :text => true
    else
      render :text => false
    end
  end
end
