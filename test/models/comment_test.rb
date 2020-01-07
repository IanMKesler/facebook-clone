require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  def setup
    @postcomment = posts(:test_post).comments.new(author_id: users(:michael).id,
                                content: 'Test comment')
    @commentcomment = comments(:post_comment).comments.new(author_id: users(:sam).id,
                                content: 'Another test comment')
  end

  test 'should be valid' do
    assert @postcomment.valid?
    assert @commentcomment.valid?
  end

  test 'content must be present and max of 500' do
    @postcomment.content = "    "
    assert_not @postcomment.valid?
    @commentcomment.content = "a"*501
    assert_not @commentcomment.valid?
  end

  test 'can be liked' do
    like = comments(:post_comment).likes.new(user_id: users(:sam).id)
    assert like.valid?
  end
end
