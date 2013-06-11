class UserBlingsController < ApplicationController
  
  before_filter :require_login
  
  def require_login
    if session[:user_id]
      @user = User.find(session[:user_id])
    else
      redirect_to sessions_new_path
    end
  end


end