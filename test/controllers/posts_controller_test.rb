require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  def setup
    login(:michael, 'secretpassword')
    @current_user = users(:michael)
  end

  test "should get index" do
    get user_posts_path(@current_user.id)
    assert_response :success
    assert_template :index
    assert_select 'div.post', { count: 2 }
  end

  test "should redirect to another users profile" do
    get user_posts_path(users(:sam).id)
    assert_redirected_to users(:sam)
  end

  test 'create a post' do
    post user_posts_path(@current_user.id), params: { post: {
      content: 'This is a post'
    }}
    assert_response :success
    assert_equal flash.now[:success], "Posted"
    assert_equal @current_user.posts.last.content, 'This is a post'
  end

  test 'handles bad post action' do
    assert_no_difference '@current_user.posts.count' do
      post user_posts_path(@current_user.id), params: { post: {
        content: ''
      }}
      assert_equal flash.now[:danger], "Post cannot be created"
    end 
  end

  test 'delete a post' do
    assert_difference '@current_user.posts.count', -1 do
      delete user_post_path(@current_user.id, @current_user.posts.last.id)
      assert flash.now[:success]
    end
  end

  test 'handles bad destroy action' do
    assert_no_difference '@current_user.posts.count' do
      delete user_post_path(@current_user.id, 1)
      assert flash.now[:danger]
    end 
  end
end
