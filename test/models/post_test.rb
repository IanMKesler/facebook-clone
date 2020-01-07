require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def setup
    @post = Post.new(author_id: users(:michael).id,
                      content: "This is a test")
  end

  test 'should be valid' do
    assert @post.valid?
  end

  test 'should include a valid author' do
    @post.author_id = 1
    assert_not @post.valid?
    @post.author = nil
    assert_not @post.valid?
  end

  test 'content must exist and be less than 1000 characters' do
    @post.content = "  "
    assert_not @post.valid?
    @post.content = "a"*1001
    assert_not @post.valid?
  end

  test 'can be liked' do
    like = posts(:one).likes.new(user_id: users(:michael).id)
    assert like.valid?
  end
end
