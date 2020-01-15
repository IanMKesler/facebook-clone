class CommentsController < ApplicationController
    before_action :authenticate_user!
    before_action :find_commentable, only: [:new, :create]

    def new
        respond_to do |format|
            format.js
        end
    end

    def create
        begin
            raise ActiveRecord::RecordNotFound unless @commentable
            @comment = @commentable.comments.new(comment_params)
            if @comment.save
                flash.now[:success] = "Comment posted"
            else
                flash.now[:danger] = "Comment could not be posted"
            end
        rescue ActiveRecord::RecordNotFound
            flash.now[:danger] = "Commentable not found"
        end
        respond_to do |format|
            format.js
        end
    end

    def destroy
        begin
            @comment = current_user.comments.find(params[:id])
            @comment.destroy
            flash.now[:success] = "Comment deleted"
        rescue ActiveRecord::RecordNotFound
            flash.now[:danger] = "Comment could not be found"
        end
        respond_to do |format|
            format.js
        end
    end


    private
        def comment_params
            permitted = params.require(:comment).permit(:content)
            permitted[:author_id] = current_user.id
            permitted
        end

        def find_commentable
            begin
                if params[:comment_id]
                    @commentable = Comment.find(params[:comment_id])
                elsif params[:post_id]
                    @commentable = Post.find(params[:post_id])
                end
            rescue ActiveRecord::RecordNotFound
                @commentable = nil
            end   
        end
end
