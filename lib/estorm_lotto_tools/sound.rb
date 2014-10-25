module EstormLottoTools
  class Sound
    def playsound(sound)
      rootdir="/home/pi/sound/"
      sndfile=rootdir+sound
      puts "playing sound: #{sndfile}"
      system("aplay #{sndfile}") if File.exists?(sndfile)
    end
    def self.playsound(snd)
      instance=EstormLottoTools::Sound.new
      instance.playsound(snd)
    end
  end
end