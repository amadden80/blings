
class WelcomeController < ApplicationController


  class Synth

    include WaveFile

    attr_accessor :freq, :fs, :seconds, :amplitude, :filename, :tone

    # arg includes :freq, :fs, :seconds, :amplitude, :filename
    def initialize(freq, args = {})
      @freq = freq
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

    def writeWave

      filename = @filename.gsub('.wav', '')

      format = Format.new(:mono, :pcm_16, @fs)
      writer = Writer.new(Rails.root.to_s << "/public/#{filename}.wav", format)
      buffer = Buffer.new(@tone, Format.new(:mono, :float, @fs))
      writer.write(buffer)
      writer.close()

      return "/#{filename}.wav"

    end

    def makeTone
      timeVect = (0...(@seconds * @fs)).to_a
      phase = timeVect.map{|sample| sample/@fs * 2 * Math::PI * @freq}
      @tone = phase.map{|sample|  (@amplitude * Math.sin(sample)).to_f}
      return @tone
    end


    def makeSlideTone(startFreq, endFreq)
      freqVector = linspace(startFreq, endFreq, (@fs * @seconds))
      phase = cumsum(freqVector.map{|sample| sample/@fs * 2 * Math::PI})
      @tone = phase.map{|sample|  (@amplitude * Math.sin(sample)).to_f}
      puts phase
      return @tone
    end

  end


    def index
    end

    def testTone

      s = Synth.new(params[:frequency].to_f)
      s.makeTone
      @path = s.writeWave
      @frequency = params[:frequency]

      redirect_to @path
    end

    def slideTone

      s = Synth.new(params[:frequency].to_f)
      s.makeSlideTone(params[:startFreq], params[:endFreq])
      @path = s.writeWave

      redirect_to @path
    end

end