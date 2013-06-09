class BlingsController < ApplicationController

  include ApplicationHelper

  def index
    s = Synth.new({path: @path_non_user_audio, frequency: 100, filename: 'test_tone',  seconds: 4})
    s.makeTone
    s.applyFades(1000)
    path = s.writeWave()
    render text: path
  end

end