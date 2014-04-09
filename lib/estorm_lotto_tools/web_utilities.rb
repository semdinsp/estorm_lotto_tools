module EstormLottoTools
  class WebUtilities 
    def self.web_app_shutdown(params)
      webu=EstormLottoTools::WebUtilities.new
      webu.shutdown(params['restart']=='true')
    end
    def shutdown(restart=false)
      system("/bin/sync")
      flag="h"
      flag="r" if restart
      cmd="/sbin/shutdown -#{flag} now"
      osflag=(/darwin/ =~ RUBY_PLATFORM) != nil
      puts "command is: #{cmd} osflag #{osflag}"
      system(cmd) if !osflag
      cmd
    end
  end # class
end #mdoule