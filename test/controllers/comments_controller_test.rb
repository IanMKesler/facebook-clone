require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  def setup
    login(:michael, 'secretpassword')
    @current_user = users(:michael)
  end

  test 'creates a post comment' do
    assert_difference '@current_user.comments.count', 1 do
      post user_post_comments_path(posts(:second_post).author.id, 
          posts(:second_post).id), params: { comment: {
            content: "This is a comment"
          }}
      assert flash.now[:success]
    end
  end

  test 'creates a comment comment' do
    assert_difference '@current_user.comments.count', 1 do
      post user_comment_comments_path(comments(:comment_comment).author.id, 
          comments(:comment_comment).id), params: { comment: {
            content: "This is a comment"
          }}
      assert flash.now[:success]
    end
  end

  test 'handles a bad create action' do
    assert_no_difference '@current_user.comments.count' do
      post user_comment_comments_path(comments(:comment_comment).author.id, 
          1), params: { comment: {
            content: "This is a comment"
          }}
      assert flash.now[:danger]
    end
  end

  test 'deletes a post comment' do
    assert_difference '@current_user.comments.count', -2 do
      delete user_post_comment_path(@current_user.id, 
            posts(:test_post).id, 
            comments(:post_comment).id)
      assert flash.now[:success]
    end
  end

  test 'deletes a comment comment' do
    assert_difference '@current_user.comments.count', -1 do
      delete user_comment_comment_path(@current_user.id, 
            comments(:comment_comment).id,
            comments(:another_comment_comment).id)
      assert flash.now[:success]
    end
  end

  test 'handles bad destroy action' do
    assert_no_difference '@current_user.comments.count' do
      delete user_post_comment_path(@current_user.id, 
            posts(:test_post).id, 
            1)
      assert flash.now[:danger]
    end
  end
end
