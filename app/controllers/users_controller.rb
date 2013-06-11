class UsersController < ApplicationController

  include ApplicationHelper

  def new
    if session[:user_id]
      redirect_to portfolios_path
    end
    @user = User.new
  end

  def create
    user = User.new(params[:user])

    if user.save
      redirect_to portfolios_path
    else
      redirect_to new_user_path
    end

  end

end