class LikesController < ApplicationController
    before_action :authenticate_user!
    before_action :find_likeable, only: [:create]

    def create
        begin
            raise ActiveRecord::RecordNotFound unless @likeable
            @like = @likeable.likes.new(user_id: current_user.id)
            if @like.save
                flash.now[:success] = "Liked"
            else
                flash.now[:danger] = "Something went wrong"
            end
        rescue ActiveRecord::RecordNotFound
            flash.now[:danger] = "Likeble not found"
        end
        respond_to do |format|
            format.js{ render action: 'update.js.erb' }
        end
    end

    def destroy
        begin
            @like = current_user.likes.find(params[:id])
            @likeable = @like.likeable
            @like.destroy
            flash.now[:success] = "Unliked"
        rescue ActiveRecord::RecordNotFound
            flash.now[:danger] = "Like not found"
        end
        respond_to do |format|
            format.js{ render action: 'update.js.erb' }
        end
    end

    private
        def find_likeable
            begin
                if params[:post_id]
                    @likeable = Post.find(params[:post_id])
                elsif params[:comment_id]
                    @likeable = Comment.find(params[:comment_id])
                end
            rescue ActiveRecord::RecordNotFound
                @likeable = nil
            end
        end
end
