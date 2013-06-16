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
    if current_user
      redirect_to user_path(current_user)
    end
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      @user.email = @user.email.downcase
      redirect_to sessions_new_path
    else
      render :new
    end
  end

  def destroy
    user = User.find(params[:id])
    user.clear_portfolios
    user.destroy
    redirect_to :back
  end


  def show
    puts params
    @user = User.find(params[:id])
    @newPortfolio = Portfolio.new
    
    if @user
      @portfolios = @user.portfolios

      if params[:ticker] && params[:seconds]

        params[:seconds] = params[:seconds].to_f
        if params[:seconds] > 5
          params[:seconds] = 5
        elsif params[:seconds] <= 0
          params[:seconds] = 0.05
        end

        @path = nil
        emailHash = email_hash(@user.email)
        ticker = params[:ticker]
        if ticker
          testPath = (Rails.root.to_s + "/public/audio/user_audio/#{emailHash}-#{params[:seconds].to_s}-#{ticker}.wav")
          Dir[Rails.root.to_s + "/public/audio/user_audio/*"].each do |filename|
            if filename == testPath
              @path = "/audio/user_audio/#{emailHash}-#{params[:seconds].to_s}-#{ticker}.wav"
            end
          end
        end

        if @path.nil?
          @companyName, close, open = nil
          open, close, @companyName = getStockPrices(ticker)

          if close && open && @companyName && close > 0 && open > 0
            maxNum = [open, close].max
            open = ((open/maxNum)**4)*440 + 100
            close = ((close/maxNum)**4)*440 + 100
            s = Synth.new({path: $absolute_path_user_audio, filename: "#{emailHash}-#{params[:seconds].to_s}-#{ticker}",  seconds:params[:seconds]})
            s.makeSlide3rd(open.to_f, close.to_f)
            s.normalize
            s.applyFades(100)
            absolutePath = s.writeWave

            manageAudioFiles(100, 'user_audio')

            @path = absolutePath.gsub($absolute_prepath, "/")
          end
        end
      end
    end

  end


  private

  def ensure_admin
    unless current_user && current_user.admin?
      render text: 'not allowed'
    end
  end



end