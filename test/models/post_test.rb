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
    like = posts(:test_post).likes.new(user_id: users(:sam).id)
    assert like.valid?
  end

  test 'deletes likes and comments when deleted' do
    things = {
      likes: posts(:test_post).likes,
      comments: posts(:test_post).comments
    }
    things.each do |key, value|
      assert_not value.empty?
    end
    posts(:test_post).destroy
    things.each do |key, value|
      assert value.empty?
    end
  end
end
