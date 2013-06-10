class BlingsController < ApplicationController

  include ApplicationHelper

  def index
  end

  def bling

    close, open = getStockPrices(params[:ticker])

    puts "*****"
    puts params[:ticker]
    puts open
    puts close
    puts "*****"

    maxNum = [open, close].max

    open = (open/maxNum)*440 + 100
    close = (close/maxNum)*440 + 100

    s = Synth.new({path: $absolute_path_test_audio, filename: "tone-#{params[:ticker]}",  seconds: 0.25})
    s.makeSlide3rd(open.to_f, close.to_f)
    s.normalize
    s.applyFades(100)
    absolutePath = s.writeWave

    manageAudioFiles(100)

    path = absolutePath.gsub($absolute_prepath, "/")
    redirect_to path
  end

end