
class WelcomeController < ApplicationController
  

  class Synth

    include WaveFile

    attr_accessor :freq

    def initialize(freq)
      @freq = freq
    end

    def makeTone

      fs = 44100.0;
      seconds = 0.25;
      amplitude = 0.9;

      timeVect = (0...(seconds * fs)).to_a
      phase = timeVect.map{|sample| sample/fs * 2 *Math::PI * @freq}
      sine = phase.map{|sample|  (amplitude * Math.sin(sample)).to_f}

      # begin
      #   file = File.open(Rails.root.to_s << "/public/testWhooo", "w")
      #   file.write("[#{sine.join(", ")}]") 
      # rescue IOError => e
      #   puts e
      # ensure
      #   file.close unless file == nil
      # end

      format = Format.new(:mono, :pcm_16, fs)
      writer = Writer.new(Rails.root.to_s << "/public/test.wav", format)
      buffer = Buffer.new(sine, Format.new(:mono, :float, fs))
      writer.write(buffer)
      writer.close()

      return "/test.wav"

    end


  end


  def index
  end

  def test
    
    s = Synth.new(params[:frequency].to_f)
    @path = s.makeTone
    @frequency = params[:frequency]

  end



end
