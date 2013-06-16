class BlingsController < ApplicationController

  include ApplicationHelper

  def index

  end

  def bling

    ticker = params[:ticker]
    if ticker
      @companyName, close, open = nil
      open, close, @companyName = getStockPrices(ticker)

      @path = nil
      testPath = (Rails.root.to_s + "/public/audio/non_user_audio/tone-#{ticker}.wav")
      Dir[Rails.root.to_s + "/public/audio/non_user_audio/*"].each do |filename|
        if filename == testPath
          @path = "/audio/non_user_audio/tone-#{ticker}.wav"
        end
      end

      if @path.nil?
        if close && open && @companyName && close > 0 && open > 0
          puts close
          puts open
          maxNum = [open, close].max

          open = ((open/maxNum)**4)*440 + 100
          close = ((close/maxNum)**4)*440 + 100

          s = Synth.new({path: $absolute_path_non_user_audio, filename: "tone-#{ticker}",  seconds:1})
          s.makeSlide3rd(open.to_f, close.to_f)
          s.normalize
          s.applyFades(100)
          absolutePath = s.writeWave

          manageAudioFiles(50, 'non_user_audio')

          @path = absolutePath.gsub($absolute_prepath, "/")
        else
          redirect_to root_path
        end
      end
    end

  end


end