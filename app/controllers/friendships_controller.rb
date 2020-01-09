class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = User.find(params[:user_id])
    @friends = @user.friends
  end

  def create
    @friendship = current_user.requester_friendships.new(friendship_params)
    if @friendship.save
      flash.now[:success] = "You are now friends"
    else
      flash.now[:danger] = "Unable to become friends"
    end
  end

  def destroy
    begin
      friendship = current_user.friendships.find(params[:id])
      friendship.destroy
      flash.now[:success] = "No longer friends"
    rescue ActiveRecord::RecordNotFound
      flash.now[:danger] = "No friend found"
    end    
  end

  private
    def friendship_params
      params.require(:friendship).permit(:requestee_id)
    end
end
