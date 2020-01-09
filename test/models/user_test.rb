require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(first_name: "Example", last_name: "User", email: "user@example.com",
                    password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
      first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
      foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    @user.email = 'michael_bubli@gmail.com'
    assert_not @user.valid?
  end

  test 'can like comments and posts' do
    comment_like = users(:michael).likes.new(likeable_id: comments(:comment_comment).id,
                                              likeable_type: 'Comment')
    assert comment_like.valid?
    post_like = users(:ashley).likes.new(likeable_id: posts(:third_post).id,
                                          likeable_type: 'Post')
    assert post_like.valid?
  end

  test 'deleting a user deletes its posts,comments,friendships, friend requests and likes' do
    things = {
      posts: users(:michael).posts,
      comments: users(:michael).comments,
      requester_friendships: users(:michael).requester_friendships,
      requestee_friendships: users(:michael).requestee_friendships,
      recieved_requests: users(:michael).recieved_requests,
      sent_requests: users(:michael).sent_requests,
      likes: users(:michael).likes
    }
    things.each do |key, value|
      assert_not value.empty?
    end
    users(:michael).destroy
    things.each do |key, value|
      assert value.empty?
    end
  end

  test 'feed handles empty friend_ids array' do
    users(:sam).feed
  end
end
