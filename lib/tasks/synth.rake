
# # require 'pry'
require 'wavefile'
include WaveFile
require 'matrix.rb'


class Synth

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

    begin
      file = File.open("test", "w")
      file.write("[#{sine.join(", ")}]") 
    rescue IOError => e
      puts e
    ensure
      file.close unless file == nil
    end

  end


  format = Format.new(:mono, :pcm_16, fs)
  writer = Writer.new("../../public/test.wav", format)
  buffer = Buffer.new(sine, Format.new(:mono, :float, fs))
  writer.write(buffer)
  writer.close()

end

