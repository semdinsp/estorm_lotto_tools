module EstormLottoTools
  class WebUtilities 
    def shutdown(restart=false)
      system("/bin/sync")
      flag="h"
      flag="r" if restart
      cmd="/sbin/shutdown -#{flag} now"
      puts "command is: #{cmd}"
      system(cmd) if !(/darwin/ =~ RUBY_PLATFORM) != nil
    end
  end # class
end #mdoule