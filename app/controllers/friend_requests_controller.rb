class FriendRequestsController < ApplicationController
    before_action :authenticate_user!
    before_action :correct_user, only: [:index]

    def index
        @requests = User.find(params[:user_id]).recieved_requests
    end

    def create
        @request = current_user.sent_requests.new(request_params)
        if @request.save
            flash.now[:success] = "Friend request sent"
        else
            flash.now[:danger] = "Request unable to be sent"
        end
    end

    def destroy
        begin
            @request = current_user.sent_requests.find(params[:id])
            @request.destroy
            flash.now[:success] = "Request rescinded"
        rescue ActiveRecord::RecordNotFound
            flash.now[:danger] = "No request found"
        end        
    end


    private
        def request_params
            params.require(:friend_request).permit(:invitee_id)
        end
end
