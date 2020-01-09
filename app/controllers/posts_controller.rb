class PostsController < ApplicationController
    before_action :authenticate_user!
    before_action :correct_user, only: [:index]

    def index
        @posts = current_user.feed
    end

    def create
        @post = current_user.posts.new(post_params)
        if @post.save
            flash.now[:success] = "Posted"
        else
            flash.now[:danger] = "Post cannot be created"
        end
    end

    def destroy
        begin
            @post = current_user.posts.find(params[:id])
            @post.destroy
            flash.now[:success] = "Post deleted"
        rescue ActiveRecord::RecordNotFound
            flash.now[:danger] = "No post found"
        end
    end

    private
        def post_params
            params.require(:post).permit(:content)
        end
end
