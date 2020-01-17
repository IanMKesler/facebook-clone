class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = User.find(params[:user_id])
    @friends = @user.friends
  end

  def create
    @friendship = current_user.requester_friendships.new(friendship_params)
    @friend_request = current_user.recieved_requests.where(inviter_id: friendship_params[:requestee_id]).first
    if @friendship.save
      flash.now[:success] = "You are now friends"
    else
      flash.now[:danger] = "Unable to become friends"
    end
    respond_to do |format|
      format.js
    end
  end

  def destroy
    begin
      friendship = current_user.friendships.find(params[:id])
      @user = friendship.requester == current_user ? friendship.requestee : friendship.requester #try passing as param????
      friendship.destroy
      flash.now[:success] = "No longer friends"
    rescue ActiveRecord::RecordNotFound
      flash.now[:danger] = "No friend found"
    end 
    respond_to do |format|
      format.js
    end   
  end

  private
    def friendship_params
      params.require(:friendship).permit(:requestee_id)
    end
end
