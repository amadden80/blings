

class WelcomeController < ApplicationController


  include ApplicationHelper

  def index
  end

  def test

    @filepaths = Array.new
    freq = 440
    lowFreq = 440
    highFreq = 500
    seconds = 1
    fadeSamples = 100
    filepath = $absolute_path_test_audio

    s = Synth.new({path: filepath, frequency: freq, filename: 'test_tone',  seconds: seconds})
    s.makeTone
    s.applyFades(fadeSamples)
    absolutePath = s.writeWave
    @filepaths << absolutePath.gsub($absolute_prepath, "")

    s = Synth.new({path: filepath, filename: 'test_slideTone_up',  seconds: seconds})
    s.makeSlideTone(lowFreq, highFreq)
    s.applyFades(fadeSamples)
    absolutePath = s.writeWave
    @filepaths << absolutePath.gsub($absolute_prepath, "")

    s = Synth.new({path: filepath, filename: 'test_slideTone_down',  seconds: seconds})
    s.makeSlideTone(1000, lowFreq)
    s.applyFades(fadeSamples)
    absolutePath = s.writeWave
    @filepaths << absolutePath.gsub($absolute_prepath, "")

    s = Synth.new({path: filepath, filename: 'test_slide3rd_up', seconds: seconds})
    s.makeSlide3rd(lowFreq, highFreq)
    s.normalize
    s.applyFades(fadeSamples)
    absolutePath = s.writeWave
    @filepaths << absolutePath.gsub($absolute_prepath, "")

    s = Synth.new({path: filepath, filename: 'test_slide3rd_down', seconds: seconds})
    s.makeSlide3rd(highFreq, lowFreq)
    s.normalize
    s.applyFades(fadeSamples)
    absolutePath = s.writeWave

    s = Synth.new({path: filepath, filename: 'test_slide3rd_flat', seconds: seconds})
    s.makeSlide3rd(freq, freq)
    s.normalize
    s.applyFades(fadeSamples)
    @filepaths << absolutePath.gsub($absolute_prepath, "")

  end


  def testTone

    s = Synth.new({path: $absolute_path_test_audio, frequency: params[:frequency].to_f, filename: 'test_tone',  seconds: 1})
    s.makeTone
    s.applyFades(100)
    absolutePath = s.writeWave
    path = absolutePath.gsub($absolute_prepath, "/")

    redirect_to path
  end

  def slideTone

    s = Synth.new({path: $absolute_path_test_audio, filename: 'test_slideTone',  seconds: 1})
    s.makeSlideTone(params[:startFreq].to_f, params[:endFreq].to_f)
    s.applyFades(100)
    absolutePath = s.writeWave
    path = absolutePath.gsub($absolute_prepath, "/")

    redirect_to path
  end

  def slide3rd

    s = Synth.new({path: $absolute_path_test_audio, filename: 'test_slide3rd', seconds: 1})
    s.makeSlide3rd(params[:startFreq].to_f, params[:endFreq].to_f)
    s.applyFades(100)
    absolutePath = s.writeWave
    path = absolutePath.gsub($absolute_prepath, "/")

    redirect_to path
  end

end


