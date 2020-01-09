class ApplicationController < ActionController::Base
  protect_from_forgery

  def after_sign_in_path_for(resource_or_scope)
    edit_user_registration_path
  end
    
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  def correct_user
    @user = User.find(params[:user_id])
    redirect_to(@user) unless current_user == @user
  end
end
