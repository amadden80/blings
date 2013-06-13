class UsersController < ApplicationController

  include ApplicationHelper

  before_filter :ensure_admin, only: [:index, :destroy]

  def index
    @user = []
    if current_user && current_user.admin?
      @users = User.all
    end
  end

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

  def destroy
    user = User.find(params[:id])
    user.destroy
    redirect_to :back
  end


  private

  def ensure_admin
    unless current_user && current_user.admin?
      render text: 'not allowed'
    end
  end


end