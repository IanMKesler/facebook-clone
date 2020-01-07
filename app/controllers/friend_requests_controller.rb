class FriendRequestsController < ApplicationController
    before_action :authenticate_user!

    def index
        @requests = User.find(params[:user_id]).requests
    end
end
