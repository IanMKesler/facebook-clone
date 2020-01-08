require 'test_helper'

class FriendRequestsControllerTest < ActionDispatch::IntegrationTest

  def setup
    login(:michael, 'secretpassword')
    @current_user = users(:michael)
  end

  test 'retrieves list of requests for current logged in user' do
    get user_friend_requests_path(@current_user.id)
    assert_template :index
    assert_select 'h2', { count: @current_user.recieved_requests.count }
  end

  test 'redirects to other users profile page' do
    get user_friend_requests_path(users(:sam).id)
    assert_redirected_to users(:sam)
  end


  test 'can send a valid request' do
    post user_friend_requests_path(@current_user.id), params: {friend_request: {
      invitee_id: users(:sam).id
    }}
    assert_equal flash.now[:success], "Friend request sent"
    request = @current_user.sent_requests.last
    assert_equal request.invitee_id, users(:sam).id
  end

  test 'cannot send invalid request' do
    post user_friend_requests_path(@current_user.id), params: {friend_request: {
      invitee_id: users(:ashley).id
    }}
    assert_equal flash.now[:danger], "Request unable to be sent"
    request = @current_user.sent_requests.last
    assert_not_equal request.invitee_id, users(:ashley).id
  end

  test 'can rescind an existing request' do
    request = @current_user.sent_requests.last
    delete user_friend_request_path(@current_user.id,request.id)
    assert_equal flash.now[:success], "Request rescinded"
    assert_not_equal @current_user.sent_requests.last, request    
  end

  test 'catches a bad destroy action' do
    request = @current_user.sent_requests.last
    delete user_friend_request_path(@current_user.id,1)
    assert_equal flash.now[:danger], "No request found"
    assert_equal @current_user.sent_requests.last, request    
  end
end
