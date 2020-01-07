require 'test_helper'

class FriendRequestTest < ActiveSupport::TestCase
  def setup
    @request = FriendRequest.new(inviter_id: users(:michael).id,
                                  invitee_id: users(:sam).id)                          
  end

  test 'should be valid' do
    assert @request.valid?
  end

  test 'should require both inviter and invitee id' do
    @request.inviter_id = nil
    assert_not @request.valid?
    @request.inviter_id = users(:michael).id
    @request.invitee_id = nil
    assert_not @request.valid?
    @request.invitee_id = users(:sam).id
  end

  test 'should include a valid inviter and invitee' do
    @request.inviter_id = 1
    assert_not @request.valid?
    @request.inviter_id = users(:michael).id
    @request.invitee_id = 2
    assert_not @request.valid?
    @request.invitee_id = users(:sam).id
  end

  test 'should not allow multiple requests' do
    @request.save
    assert_not @request.valid?
    @request.inviter_id, @request.invitee_id = @request.invitee_id, @request.inviter_id
    assert_not @request.valid?
    FriendRequest.last.delete
  end

  test 'should not allow requests between friends' do
    request = FriendRequest.new(inviter_id: users(:michael).id,
                                invitee_id: users(:ashley).id)
    assert_not request.valid?
    request.inviter_id, request.invitee_id = request.invitee_id, request.inviter_id
    assert_not request.valid?
  end
end
