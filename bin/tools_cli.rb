#!/usr/bin/env ruby
require 'rubygems'
require 'thor'
require 'estorm_lotto_tools'
# needs upgrade to thor
#puts "Check emailcheck.rb check  <address>  --from <from>"
# CALL IT LIKE THIS bin/create_free_entry_list.rb process --filename testfree
class ToolsCli < Thor
  
    
    desc "draws", "get draws data"
    option :host, :required => true
    option :token, :required => true
    def draws
      wb=EstormLottoTools::WebJsonData.new
      res=wb.get_lotto_draw(options[:host],options[:token])
      puts res
    end
    
    desc "signage", "send signage data"
    def signage
      wb=EstormLottoTools::DigitalSignage.new
      data=wb.send_4d_results
      filemgr=EstormLottoTools::Files.new
      filemgr.write_file('/home/pi/info-beamer-pi/estorm/nodemgr/drawdata','4d.json',data.to_json) if !data.nil?
      puts data
    end
    desc "donations", "count of donations"
    def donations
        wb=EstormLottoTools::WebJsonData.new
        res=wb.get_donations_count('estorm-sms','stxpgBdjcrWt9iAZUAyZ')
        puts res
    end
    
    desc "donator_list", "list of donators"
    def donator_list
        wb=EstormLottoTools::WebJsonData.new
        res=wb.get_donators_list('estorm-sms','stxpgBdjcrWt9iAZUAyZ')
        puts res
    end
    
    desc "obfuscate", "obfuscate list of donators"
    def obfuscate
        wb=EstormLottoTools::WebJsonData.new
        res=wb.get_donators_list('estorm-sms','stxpgBdjcrWt9iAZUAyZ')
        res=wb.obfuscate_keys(res)
        puts res
    end
    
    
    desc "mountboot", "mount boot disk"
    def mountboot
      wb=EstormLottoTools::Basic.new
      wb.make_config_fs_readable
    end
    
end

ToolsCli.start(ARGV)

