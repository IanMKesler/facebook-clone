class PostsController < ApplicationController
    before_action :authenticate_user!
    before_action :correct_user, only: [:index]

    def index
        @posts = current_user.feed
    end

    def create
        @post = current_user.posts.new(post_params)
        if @post.save
            flash[:success] = "Posted"
        else
            flash[:danger] = "Post cannot be created"
        end
        respond_to do |format|
            format.js
        end
    end

    def destroy
        begin
            @post = current_user.posts.find(params[:id])
            @post.destroy
            flash[:success] = "Post deleted"
        rescue ActiveRecord::RecordNotFound
            flash[:danger] = "No post found"
        end
        respond_to do |format|
            format.js
        end
    end

    private
        def post_params
            params.require(:post).permit(:content)
        end

        def belongs_to_user(object)
            object.author_id == current_user.id
        end
end
