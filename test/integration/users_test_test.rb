require 'test_helper'

class UsersTestTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  def setup
    @user = users(:michael)
    @user.confirm
  end

  test 'should show valid users page' do
    sign_in @user
    get users_path
    assert_response 200


    assert_select 'form[action=?]', users_path, count: 1
    assert_select 'div#user-widget', count: 7
  end
end
