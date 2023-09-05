class FriendsController < ApplicationController
  before_action :authenticate_user!

  def accept_friend_request
    friendship = current_user.friendships.find(params[:id])
    friendship.update(status: 'accepted')
    flash[:notice] = "You are now friends with #{friendship.friend.profile.first_name}."
    redirect_to friend_requests_friends_path
  end

  def reject_friend_request
    friendship = current_user.friendships.find(params[:id])
    friendship.destroy
    flash[:notice] = "Friend request from #{friendship.friend.profile.first_name} rejected."
    redirect_to friend_requests_friends_path
  end
  
  def destroy
    friend = User.find(params[:id])
    friendship = current_user.friendships.find_by(friend_id: friend.id)
    if friendship&.destroy
      flash[:notice] = "Removed #{friend.name} from your friends."
    else
      flash[:alert] = "Unable to remove friend."
    end
    redirect_to root_path
  end

  def friend_requests
    @friend_requests = current_user.friendships.where(status: 'pending')
    p @friend_requests
  end
end