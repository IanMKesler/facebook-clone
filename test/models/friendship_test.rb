require 'test_helper'

class FriendshipTest < ActiveSupport::TestCase
  def setup
    @friendship = Friendship.new(requester_id: users(:michael).id,
                                  requestee_id: users(:migel).id)
  end

  test 'should be valid' do
    assert @friendship.valid?
  end

  test 'should require both requester and requestee id' do
    @friendship.requester_id = nil
    assert_not @friendship.valid?
    @friendship.requester_id = users(:michael).id
    @friendship.requestee_id = nil
    assert_not @friendship.valid?
    @friendship.requestee_id = users(:sarah).id
  end

  test 'should require a valid requester and requestee' do
    @friendship.requester_id = 3
    assert_not @friendship.valid?
    @friendship.requester_id = users(:michael).id
    @friendship.requestee_id = 4
    assert_not @friendship.valid?
    @friendship.requestee_id = users(:sarah).id
  end

  test 'should not allow friendships without a request' do
    friendship = Friendship.new(requester_id: users(:michael).id,
                                requestee_id: users(:sam).id)
    assert_not friendship.valid?
    friendship.requester_id, friendship.requestee_id = friendship.requestee_id, friendship.requester_id     
    assert_not friendship.valid?                           
  end
end
