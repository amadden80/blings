
module ApplicationHelper

  $absolute_prepath = Rails.root.to_s << "/public/"
  $absolute_path_non_user_audio = Rails.root.to_s << "/public/audio/non_user_audio/"
  $absolute_path_user_audio = Rails.root.to_s << "/public/audio/user_audio/"
  $absolute_path_test_audio = Rails.root.to_s << "/public/audio/test_audio/"

  class Synth

    include WaveFile

    attr_accessor :freq, :fs, :seconds, :amplitude, :filename, :path, :tone

    # arg includes :freq, :fs, :seconds, :amplitude, :filename
    def initialize(args = {})
      @path = args[:path]
      @freq = args[:frequency]
      @fs = args[:fs]
      @seconds = args[:seconds]
      @amplitude = args[:amplitude]
      @filename = args[:filename]

      @path ||= './'
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
      local_path = @path
      local_path += "#{filename}.wav"

      format = Format.new(:mono, :pcm_16, @fs)
      writer = Writer.new(local_path, format)
      buffer = Buffer.new(@tone, Format.new(:mono, :float, @fs))
      writer.write(buffer)
      writer.close()

      return local_path

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
      tone1 = phase1.map{|sample| (@amplitude * Math.sin(sample)).to_f}
      tone2 = phase2.map{|sample| (@amplitude * Math.sin(sample)).to_f}
      tone3 = phase3.map{|sample| (0.9*@amplitude * Math.sin(sample)).to_f}
      @tone = []
      tone1.each_with_index{ |sample, index| @tone << (sample + tone2[index] + tone3[index])}
      
      return @tone
    end

  end


  def deleteOldFile(filename, keepSeconds)
      
      puts "Filename: #{filename}"
      puts "Now: #{Time.now}"
      
      if (Time.now - File.stat(filename).ctime) > keepSeconds
        File.delete(filename)
        puts "*/*/*/* Delete: #{filename} */*/*/*"
      end
  end


  # You will need to manage this for other than non_user_content
  def manageAudioFiles(maxNumFiles)

    fileNumber = Dir[(Rails.root.to_s + "/public/audio/non_user_audio/*")].count
    keepSeconds = 7200

    while fileNumber > maxNumFiles
      keepSeconds *= 0.5
      Dir[(Rails.root.to_s + "/public/audio/non_user_audio/*")].each do |filename| 
      deleteOldFile(filename, keepSeconds)
      end
      fileNumber = Dir[(Rails.root.to_s + "/public/audio/non_user_audio/*")].count
    end

  end



  def getStockPrices(ticker)
    unless ticker.nil?
      ticker = ticker.chomp.upcase.split(' ').first
      stockResponse = YahooFinance::get_quotes(YahooFinance::StandardQuote, ticker)[ticker]
        if stockResponse.nil?
          return false
        else
          close = stockResponse.previousClose
          open = stockResponse.lastTrade
          companyName = stockResponse.name
          return open, close, companyName
        end
      else
        return false
    end

  end


  def getDetaulStockAudioPath(ticker)    

    close, open = getStockPrices(ticker)
    
    if !close.nil? && !close.nil?
      maxNum = [open, close].max
      open = ((open/maxNum)**3)*440 + 100
      close = ((close/maxNum)**3)*440 + 100
      s = Synth.new({path: $absolute_path_non_user_audio, filename: "tone-#{ticker}",  seconds:1.5})
      s.makeSlide3rd(open.to_f, close.to_f)
      s.normalize
      s.applyFades(100)
      absolutePath = s.writeWave

      manageAudioFiles(100)

      path = absolutePath.gsub($absolute_prepath, "/")
    else
      path = ''
    end

    return path
  end


end

