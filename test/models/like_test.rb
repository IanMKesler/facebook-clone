require 'test_helper'

class LikeTest < ActiveSupport::TestCase
  def setup 
    @like = Like.new(user_id: users(:michael).id,
                      likeable_type: 'Post', likeable_id: posts(:test_post).id)
  end

  test 'should be valid' do
    assert @like.valid?
  end

  test 'must contain valid user' do
    @like.user_id = 1
    assert_not @like.valid?
    @like.user_id = nil
    assert_not @like.valid?
  end

  test 'must contain valid likeable type and id' do
    @like.likeable_type = nil
    assert_not @like.valid?
    @like.likeable_type = 'Post'
    @like.likeable_id = nil
    assert_not @like.valid?
    @like.likeable_id = 1
    assert_not @like.valid?
  end
end
