class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    #skip_before_action :authenticate_user!

    def google_oauth2
        auth = request.env["omniauth.auth"]
        user = User.where(provider: auth["provider"], uid: auth["uid"])
                .first_or_initialize(email: auth["info"]["email"])
        name = auth["info"]["name"].split(" ")
        user.first_name = name[0]
        user.last_name = name[1]
        user.save!
    
        user.remember_me = true
        sign_in(:user, user)
    
        redirect_to after_sign_in_path_for(user)
    end    
end
