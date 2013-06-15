class SessionsController < ApplicationController
  

  def new
    if session[:user_id]
      redirect_to user_path(session[:user_id])
    end
  end

  def create

    user = User.find_by_email(params[:email])
    if user.present?
      puts 'located_user: ' + user.username
      authenticated_user = user.authenticate params[:password]
      if authenticated_user
        session[:user_id] = authenticated_user.id
        puts session
        redirect_to user_path(session[:user_id])
      else
        redirect_to sessions_new_path
      end
    else
      redirect_to sessions_new_path
    end
  end
    
  def destroy
    session[:user_id] = nil
    redirect_to sessions_new_path
  end

end