require 'test_helper'

class FriendshipsControllerTest < ActionDispatch::IntegrationTest
  def setup
    login(:michael, 'secretpassword')
    @current_user = users(:michael)
  end

  test "should get index" do
    get user_friends_path(@current_user.id)
    assert_response :success
    assert_template :index
    assert_select 'h2', { count: @current_user.friends.count }
    get user_friends_path(users(:sam).id)
    assert_response :success
    assert_template :index
    assert_select 'h2', { count: users(:sam).friends.count }
  end

  test "should create a friendship" do
    post user_friends_path(@current_user.id), params: { friendship: {
      requestee_id: users(:migel).id
    }}
    assert_response :success
    assert_equal flash.now[:success], "You are now friends"
    assert @current_user.friends.find(users(:migel).id)
  end

  test "should handle a bad create action" do
    post user_friends_path(@current_user.id), params: { friendship: {
      requestee_id: users(:sarah).id
    }}
    assert_response :success
    assert_equal flash.now[:danger], "Unable to become friends"
  end

  test 'should destroy a friendship' do
    friendship = @current_user.requester_friendships.last
    delete user_friend_path(@current_user.id, friendship.id)
    assert_equal flash.now[:success], "No longer friends"
    assert_raise ActiveRecord::RecordNotFound do
      @current_user.requester_friendships.find(friendship.id)
    end
  end

  test 'should handle a bad destroy request' do
    assert_no_difference '@current_user.friends.count' do
      delete user_friend_path(@current_user.id, 1)
      assert_equal flash.now[:danger], "No friend found"
    end 
  end
end
