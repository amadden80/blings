class BlingsController < ApplicationController

  include ApplicationHelper

  def index
  end

  def bling
    s = Synth.new({path: $absolute_path_non_user_audio, frequency: params[:frequency].to_f, filename: 'tone',  seconds: 1})
    s.makeTone
    s.applyFades(100)
    absolutePath = s.writeWave
    path = absolutePath.gsub($absolute_prepath, "/")

    redirect_to path
  end

end