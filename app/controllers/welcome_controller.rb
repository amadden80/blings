


class WelcomeController < ApplicationController



  class Synth

    include WaveFile

    attr_accessor :freq, :fs, :seconds, :amplitude, :filename, :tone

    # arg includes :freq, :fs, :seconds, :amplitude, :filename
    def initialize(args = {})
      @freq = args[:frequency]
      @fs = args[:fs]
      @seconds = args[:seconds]
      @amplitude = args[:amplitude]
      @filename = args[:filename]

      @freq ||= 440.0
      @fs ||= 44100.0
      @seconds ||= 0.25
      @amplitude ||= 0.9
      @filename ||= 'test'
      @tone = []

      @twoPI = (2 * Math::PI)
    end


    def linspace(lowNum, highNum, numSamples)
      lowNum = lowNum.to_f
      highNum = highNum.to_f
      numSamples = numSamples.to_f

      aToB = (0...(numSamples)).to_a
      dif = highNum - lowNum
      aToB.map do |sample|
        ((sample/numSamples) * dif) + lowNum
      end
    end

    def cumsum(vect)
      cumSum = 0
      vect = vect.map do|sample|  
        cumSum = cumSum + sample
        cumSum
      end
      return vect
    end

    def normalize(newMax = 0.98 )
      maxVal = @tone.max {|a,b| a.abs <=> b.abs }
      @tone = @tone.map{|sample| newMax*(sample/maxVal)}
    end

    
    def applyFadeIn(sampsIn)
      ramp = linspace(0.0, 1.0, sampsIn.to_f)
      ramp.each_with_index { |sample, indx| @tone[indx] *= sample }
    end

    def applyFadeOut(sampsIn)
      ramp = linspace(0.0, 1.0, sampsIn.to_f)
      vectLeng = @tone.count
      ramp.each_with_index { |sample, indx| @tone[vectLeng-indx-1] *= sample }
    end

    def applyFades(numSamples)
      applyFadeOut(numSamples.to_f)
      applyFadeIn(numSamples.to_f)
    end

    def writeWave

      filename = @filename.gsub('.wav', '')

      format = Format.new(:mono, :pcm_16, @fs)
      writer = Writer.new(Rails.root.to_s << "/public/audio/test_audio/#{filename}.wav", format)
      buffer = Buffer.new(@tone, Format.new(:mono, :float, @fs))
      writer.write(buffer)
      writer.close()

      return "audio/test_audio/#{filename}.wav"

    end

    def timeGen
      (0...(@seconds * @fs)).to_a
    end

    def makeTone(freq = @freq)
      timeVect = timeGen
      phase = timeVect.map{|sample| sample/@fs * @twoPI * freq}
      @tone = phase.map{|sample|  (@amplitude * Math.sin(sample)).to_f}
      return @tone
    end


    def makeSlideTone(startFreq, endFreq, args = {})
      freqVector = linspace(startFreq, endFreq, (@fs * @seconds))
      phase = cumsum(freqVector.map{|sample| sample/@fs * @twoPI})
      @tone = phase.map{|sample|  (@amplitude * Math.sin(sample)).to_f}
      
      return @tone
    end


    def makeSlide3rd(startFreq, endFreq, args = {})

      freqVector1 = linspace(startFreq, endFreq, (@fs * @seconds))
      
      if startFreq < endFreq
        freqVector2 = freqVector1.map{|sample| (sample * 1.1875)}
      else
        freqVector2 = freqVector1.map{|sample| (sample * 1.25)}
      end

      freqVector3 = freqVector1.map{|sample| (sample * 1.5)}


      phase1 = cumsum(freqVector1.map{|sample| sample/@fs * @twoPI})
      phase2 = cumsum(freqVector2.map{|sample| sample/@fs * @twoPI})
      phase3 = cumsum(freqVector3.map{|sample| sample/@fs * @twoPI})
      tone1 = phase1.map{|sample|  (@amplitude * Math.sin(sample)).to_f}
      tone2 = phase2.map{|sample|  (@amplitude * Math.sin(sample)).to_f}
      tone3 = phase3.map{|sample|  (@amplitude * Math.sin(sample)).to_f}
      @tone = []
      tone1.each_with_index{ |sample, index| @tone << (sample + tone2[index] + tone3[index])}
      
      return @tone
    end

  end


  def index
  end

  def test

    @paths = []
    freq = 440
    lowFreq = 440
    highFreq = 500
    seconds = 1
    fadeSamples = 100

    s = Synth.new({frequency: freq, filename: 'test_tone',  seconds: seconds})
    s.makeTone
    s.applyFades(fadeSamples)
    @paths << s.writeWave

    s = Synth.new({filename: 'test_slideTone_up',  seconds: seconds})
    s.makeSlideTone(lowFreq, highFreq)
    s.applyFades(fadeSamples)
    @paths << s.writeWave

    s = Synth.new({filename: 'test_slideTone_down',  seconds: seconds})
    s.makeSlideTone(1000, lowFreq)
    s.applyFades(fadeSamples)
    @paths << s.writeWave

    s = Synth.new({filename: 'test_slide3rd_up', seconds: seconds})
    s.makeSlide3rd(lowFreq, highFreq)
    s.normalize
    s.applyFades(fadeSamples)
    @paths << s.writeWave

    s = Synth.new({filename: 'test_slide3rd_down', seconds: seconds})
    s.makeSlide3rd(highFreq, lowFreq)
    s.normalize
    s.applyFades(fadeSamples)
    @paths << s.writeWave

    s = Synth.new({filename: 'test_slide3rd_flat', seconds: seconds})
    s.makeSlide3rd(freq, freq)
    s.normalize
    s.applyFades(fadeSamples)
    @paths << s.writeWave


  end


  def testTone

    s = Synth.new({frequency: params[:frequency].to_f, filename: 'test_tone',  seconds: 1})
    s.makeTone
    s.applyFades(100)
    @path = s.writeWave
    @frequency = params[:frequency]

    redirect_to @path
  end

  def slideTone

    s = Synth.new({filename: 'test_slideTone',  seconds: 1})
    s.makeSlideTone(params[:startFreq].to_f, params[:endFreq].to_f)
    s.applyFades(100)
    @path = s.writeWave

    redirect_to @path
  end

  def slide3rd

    s = Synth.new({filename: 'test_slide3rd', seconds: 1})
    s.makeSlide3rd(params[:startFreq].to_f, params[:endFreq].to_f)
    s.applyFades(100)
    @path = s.writeWave

    redirect_to @path
  end


end



