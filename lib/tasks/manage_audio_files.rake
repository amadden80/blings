desc "Manage audio files"

def deleteOldFile(filename, keepSeconds)

    puts "******* begin *******" 
    puts "Filename: #{filename}"
    puts "Now: #{Time.now}"
    puts "Filen Ctime: #{File.ctime(filename)}"
    puts "Keep: #{keepSeconds}"
    puts "Filename: #{filename}"

    if (Time.now - File.ctime(filename)) > keepSeconds
      File.delete(filename)
      puts "*Delete: #{filename}*"
    end

    puts "******* end *******" 
end

task :manage_nonuser_audiofiles => :environment do
  keepSeconds = 1000
  Dir[(Rails.root.to_s << "/public/audio/non_user_audio/*")].each do |filename| 
    deleteOldFile(filename, keepSeconds)
  end
end

task :manage_test_audiofiles => :environment do
  keepSeconds = 10000

  Dir[(Rails.root.to_s << "/public/audio/test_audio/*")].each do |filename|
    deleteOldFile(filename, keepSeconds)
  end
end

task :manage_user_audiofiles => :environment do
  keepSeconds = 5000
  Dir[(Rails.root.to_s << "/public/audio/user_audio/*")].each do |filename| 
    deleteOldFile(filename, keepSeconds)
  end
end


task :manage_all_audiofiles => :environment do

  keepSeconds = 7200
  Dir[("audio/non_user_audio/*")].each do |filename| 
    deleteOldFile(filename, keepSeconds)
  end
  
  keepSeconds = 172800
  Dir[("audio/user_audio/*")].each do |filename| 
    deleteOldFile(filename, keepSeconds)
  end

  keepSeconds = 10
  Dir[("/public/audio/test_audio/*")].each do |filename|
    deleteOldFile(filename, keepSeconds)
  end

end


