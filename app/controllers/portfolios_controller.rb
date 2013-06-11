class PortfoliosController < ApplicationController

  before_filter :require_login
  
  def require_login
    if session[:user_id]
      @user = User.find(session[:user_id])
      
    else
      redirect_to sessions_new_path
    end
  end

  

  include ApplicationHelper

  def index

    @portfolios = @user.portfolios
    
    @portfolioPackage = []
    
    @portfolios.each do |portfolio|
      stockPackage = []
      portfolio.stocks.each do |stock|
        path = getDetaulStockAudioPath(stock.ticker)    
        stockPackage << {ticker: stock.ticker, path: path}
      end
       @portfolioPackage << stockPackage
    end
  end

  def new
    @portfolio = Portfolio.new
  end

  def create
    portfolio = Portfolio.new(params[:portfolio])
    stock = Stock.new(ticker: params[:portfolio][:name])

    if stock.save && portfolio.save
      portfolio.stocks << stock
      @user.portfolios << portfolio
      redirect_to portfolios_path
    else
      redirect_to portfolios_new_path
    end
    
  end

  def destroy
    session[:user_id] = nil
    redirect_to sessions_new_path
  end

end