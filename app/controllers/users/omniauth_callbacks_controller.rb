# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    auth = request.env["omniauth.auth"]
    user = User.find_by(provider: auth["provider"], uid: auth["uid"])
    unless user
      user = User.find_by(email: auth["info"]["email"])
      user.assign_attributes(provider: auth["provider"], uid: auth["uid"]) if user
    end
    unless user
      name = auth["info"]["name"].split(" ")
      user = User.new(email: auth["info"]["email"], first_name: name[0], last_name: name[1], provider: auth["provider"], uid: auth["uid"], password: Devise.friendly_token)
    end
    user.save!
    sign_in(:user, user)
    

    flash[:success] = "Signed in with Google"
    redirect_to user_posts_path(user.id)
end    
end
