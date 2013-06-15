# class BlingsController < ApplicationController

#   include ApplicationHelper

#   def bling_path

#     if params[:ticker]
#       @companyName, close, open = nil
#       open, close, @companyName = getStockPrices(params[:ticker])

#       @path = nil
#       testPath = (Rails.root.to_s + "/public/audio/non_user_audio/tone-#{params[:ticker]}.wav")
#       Dir[Rails.root.to_s + "/public/audio/non_user_audio/*"].each do |filename|
#         if filename == testPath
#           @path = "/audio/non_user_audio/tone-#{params[:ticker]}.wav"
#         end
#       end

#       if @path.nil?
#         if close && open && @companyName && close > 0 && open > 0
#           puts close
#           puts open
#           maxNum = [open, close].max

#           open = ((open/maxNum)**3)*440 + 100
#           close = ((close/maxNum)**3)*440 + 100

#           s = Synth.new({path: $absolute_path_non_user_audio, filename: "tone-#{params[:ticker]}",  seconds:0.75})
#           s.makeSlide3rd(open.to_f, close.to_f)
#           s.normalize
#           s.applyFades(100)
#           absolutePath = s.writeWave

#           manageAudioFiles(100)

#           @path = absolutePath.gsub($absolute_prepath, "/")
#         else
#           redirect_to root_path
#         end
#       end
#     end

#   end


# end