module EstormLottoTools
  class WebUtilities 
    def shutdown(restart=false)
      system("/bin/sync")
      flag="h"
      flag="r" if restart
      cmd="/sbin/shutdown -#{flag} now"
      osflag=(/darwin/ =~ RUBY_PLATFORM) != nil
      puts "command is: #{cmd} osflag #{osflag}"
      system(cmd) if !osflag
    end
  end # class
end #mdoule