require 'test_helper'

class ProfileTestTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  def setup
    @user = users(:michael)
    @user.confirm
  end

  test 'should show valid profile' do
    sign_in @user
    get user_path(@user)
    assert_response 200

    assert_select 'div#user-widget', count: 2
    assert_select 'div.social-feed-separated', count: 1
  end
end
