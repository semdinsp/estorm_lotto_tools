#!/usr/bin/env ruby
require 'rubygems'
require 'thor'
require 'estorm_lotto_tools'
# needs upgrade to thor
#puts "Check emailcheck.rb check  <address>  --from <from>"
# CALL IT LIKE THIS bin/create_free_entry_list.rb process --filename testfree
class ConfigCli < Thor
    desc "dump_config", "get balance"
    option :file, :required => true
    option :dir, :required => true
    def dump_config
      wb=EstormLottoTools::ConfigMgr.new
      puts wb.read_config(options[:dir],options[:file]).inspect    
    end
    
    desc "update_config", "update the configuration file"
    option :file, :required => true
    option :dir, :required => true
    option :key, :required => true
    option :value, :required => true
    def update_config
      wb=EstormLottoTools::ConfigMgr.new
      cf=wb.read_config(options[:dir],options[:file])    
      params=cf.params
      file = File.open("#{options[:dir]}/#{options[:file]}", 'w')
      params[options[:key]]=options[:value]
      wb.update_params(params)
    end
    
    desc "identity", "get identity"
    def identity
      wb=EstormLottoTools::ConfigMgr.new
      puts wb.read_config()['identity']
    end
    
    desc "printer", "get printer"
    def printer
      wb=EstormLottoTools::ConfigMgr.new
      puts wb.read_config()['printer']
    end
end

ConfigCli.start(ARGV)