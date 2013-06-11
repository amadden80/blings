class UsersController < ApplicationController

  include ApplicationHelper

  def index
    render text: "Basic User"
  end

  def new
    @user = User.new
  end

  def create
    user = User.new(params[:user])

    if user.save
      redirect_to users_path
    else
      redirect_to new_user_path
    end

  end

end