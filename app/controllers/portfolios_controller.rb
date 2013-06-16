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
    redirect_to root_path
  end

  def new
    @portfolio = Portfolio.new
  end

  def create
    
    ticker = params[:portfolio][:name].chomp.upcase.split(' ').first
    
    unless current_user.portfolios.find_by_name(ticker)
    
      @portfolio = Portfolio.new(name: ticker)

      stock = Stock.find_by_ticker(ticker)
  
      if stock
        @portfolio.stocks << stock
        @user.portfolios << @portfolio
        redirect_to user_path(@user)
      else
        open, close, companyName = nil
        open, close, companyName = getStockPrices(ticker)
        
        if !open && !close
          redirect_to user_path(@user)
        else

          stock = Stock.new(ticker: ticker)

          if open && close && open>0.0 && close>0.0 && companyName && @portfolio.save && stock.save
            stock.name = companyName
            stock.save
            # binding.pry
            @portfolio.stocks << stock
            @user.portfolios << @portfolio
            redirect_to user_path(@user)
          else
            render :new
          end
        end
      end
    else #unless
      redirect_to user_path(@user)
    end


  end
    
  

  def destroy
    Portfolio.find(params[:id]).destroy
    redirect_to user_path(@user)
  end

end