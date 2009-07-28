class FriendsController < ApplicationController
  before_filter :authenticate

  def index
    @friends = current_user.friends
  end

  def invite
    if request.post? && !params[:emails].blank?
      params[:emails].split(",").each do |email|
        begin
          Notification.deliver_invitation(current_user, email)
        rescue => ex
          puts "Unable to deliver email to #{email} -- #{ex.message}"
        end
      end
      flash[:notice] = "Email invitations have been sent."
      redirect_to friends_path
    end
  end
  
  def index
    @friends = current_user.friends
    @inverse_friends = current_user.inverse_friends
  end
  
end
