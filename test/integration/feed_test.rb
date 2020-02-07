require 'test_helper'

class FeedTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  def setup
    @user = users(:michael)
    @user.confirm
  end

  test 'should display valid feed' do
    sign_in @user
    get user_posts_path(@user)
    assert_response 200
    
    assert_select 'form[action=?]', user_posts_path(@user), count: 1
    assert_select 'div.social-feed-separated', count: 2
  end
end
