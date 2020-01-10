require 'test_helper'

class LikesControllerTest < ActionDispatch::IntegrationTest
  def setup
    login(:michael, 'secretpassword')
    @current_user = users(:michael)
  end

  test 'creates a post like' do
    assert_difference '@current_user.likes.count', 1 do
      post user_post_likes_path(users(:sam).id,
          posts(:third_post).id)
      assert flash.now[:success]
    end
  end

  test 'creates a comment like' do
    assert_difference '@current_user.likes.count', 1 do
      post user_comment_likes_path(users(:sarah).id,
          comments(:comment_comment).id)
      assert flash.now[:success]
    end
  end

  test 'handles a bad create action' do
    assert_no_difference '@current_user.likes.count' do
      post user_comment_likes_path(users(:sarah).id,
          1)
      assert flash.now[:danger]
    end
  end

  test 'destroys a post like' do
    assert_difference '@current_user.likes.count', -1 do
      delete user_post_like_path(users(:ashley).id,
          posts(:second_post).id, likes(:one).id)
      assert flash.now[:success]
    end
  end

  test 'destroys a comment like' do
    assert_difference '@current_user.likes.count', -1 do
      delete user_comment_like_path(users(:sarah).id,
          comments(:comment_comment).id, likes(:four).id)
      assert flash.now[:success]
    end
  end
end
