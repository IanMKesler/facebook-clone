require 'test_helper'

class SignUpFlowsTest < ActionDispatch::IntegrationTest
  test 'attempt to register with invalid information' do
    get '/users/sign_up'
    assert_response :success
    assert_select 'div#error_explanation', count: 0

    post '/users', params: { user: { first_name: "", last_name: "", email: "", password: "", password_confirmation: ""}}
    assert_equal "/users", path
    assert_response 200
    assert_select 'div#error_explanation', count: 1
  end

  test 'register with valid information' do
    assert_difference 'User.count', 1 do
      post '/users', params: { user: { first_name: "test", last_name: "case", email: "test@case.com", password: "password", password_confirmation: "password" } }
    end
    assert_equal "/users", path
    assert_response 302
    assert_redirected_to root_path    
  end
end
