class PortfoliosController < ApplicationController

  before_filter :require_login
  
  def require_login
    if session[:user_id]
      @user = User.find(session[:user_id])
    else
      redirect_to session_new_path
    end
  end



  def index
    render text: "Portfolio for #{@user.username}"
  end

end