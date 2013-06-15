class PortfoliosController < ApplicationController

  before_filter :require_login
  
  private

  def require_login
    if current_user
      @user = User.find(session[:user_id])
    else
      redirect_to sessions_new_path
    end
  end

  public

  include ApplicationHelper

  def index
  end

  def new
    @portfolio = Portfolio.new
  end

  def create
    portfolio = Portfolio.new(params[:portfolio])
    stock = Stock.new(ticker: params[:portfolio][:name])

    open, close, companyName = nil
    open, close, companyName = getStockPrices(params[:portfolio][:name])
    puts  getStockPrices(params[:portfolio][:name])
    if open && close && open>0.0 && close>0.0 && companyName && stock.save && portfolio.save
      portfolio.stocks << stock
      @user.portfolios << portfolio
      redirect_to user_path(@user)
    else
      redirect_to user_path(@user)
    end
    
  end

  def destroy
    Portfolio.find(params[:id]).destroy
    redirect_to user_path(@user)
  end

end