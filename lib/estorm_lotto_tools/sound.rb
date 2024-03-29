module EstormLottoTools
  class Sound
    def playsound(sound)
      rootdir="/home/pi/sound/"
      sndfile=rootdir+sound
      puts "playing sound: #{sndfile}"
      Thread.new { system("aplay #{sndfile}") } if File.exists?(sndfile)
      File.exists?(sndfile)   #return if file exists
    end
    def self.playsound(snd)
      instance=EstormLottoTools::Sound.new
      instance.playsound(snd)
    end
  end
end