class UsersController < ApplicationController
    before_action :authenticate_user!

    def show
        @user = User.find(params[:id])
        @posts = @user.posts.order(:created_at)
        @button = button_type
    end

    private
        def button_type
            case true
            when current_user == @user
                return nil
            when current_user.friends.include?(@user)
                return 'unfriend'
            when current_user.sent_requests.where(invitee_id: @user.id).present?
                return 'sent_request'
            when current_user.recieved_requests.where(inviter_id: @user.id).present?
                return 'recieved_request'
            else
                return 'friend_request'
            end
        end
end
