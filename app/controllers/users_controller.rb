class UsersController < ApplicationController
    before_action :authenticate_user!

    def index
        if params[:search]
            @users = search(search_params)
        else
            @users = User.all
        end
        respond_to do |format|
            format.js
            format.html
        end
    end
    def show
        @user = User.find(params[:id])
        @posts = @user.posts.order(:created_at)
        @button = button_type
    end

    def update
        @user = current_user
        @posts = @user.posts.order(:created_at)
        if update_params.empty?
            flash.now[:warning] = "Please choose a file to upload"
            render 'users/show'
            return
        end
        if @user.update_attributes(update_params)
            flash[:success] = "Avatar Uploaded"
            redirect_to current_user
        else
            flash.now[:warning] = "Unable to upload file"
            render 'users/show'
        end
    end 

    private
        def update_params
            begin
                params.require(:user).permit(:avatar)
            rescue
                {}
            end
        end

        def search_params
            params.require(:search).permit(:input)
        end

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

        def search(search_params)
            keywords = search_params[:input].split(" ")
            return User.all if keywords.empty?
            if keywords.length == 2
                result = User.where('LOWER(first_name) LIKE LOWER(?) AND LOWER(last_name) LIKE LOWER(?)', keywords[0], keywords[1])
                result = User.where('LOWER(last_name) LIKE LOWER(?) AND LOWER(first_name) LIKE LOWER(?)', keywords[0], keywords[1]) if result.empty?
                result = User.where(query(keywords)) if result.empty?
            else
                result = User.where(query(keywords))
            end
            result
          end

        def query(keywords)
            query = [""]
            keywords.each do |keyword|
                query[0] += "LOWER(first_name) LIKE LOWER(?) OR LOWER(last_name) LIKE LOWER(?) OR "
                query.append(keyword, keyword)
            end
            query[0].delete_suffix!('OR ')
            query
        end
end
