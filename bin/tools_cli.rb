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
      res=wb.send_4d_results
      puts res
    end
    
    desc "mountboot", "mount boot disk"
   
    def mountboot
      wb=EstormLottoTools::Basic.new
      wb.make_config_fs_readable
    end
    
end

ToolsCli.start(ARGV)

