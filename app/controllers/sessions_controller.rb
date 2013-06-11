class SessionsController < ApplicationController
  
  def new
  end

  def create
    user = User.find_by_email(params[:email])
    puts 'located_user: ' + user.username
    if user.present?
      authenticated_user = user.authenticate params[:password]
      if authenticated_user
        session[:user_id] = authenticated_user.id
        puts session
        render text: 'You are authenticated', layout: true
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