require 'rubygems'
require 'parseconfig'

module EstormLottoTools
  class ConfigMgr
   # attr_accessor :randgen, :myrange
  def debug
    true
  end
  attr_accessor :config
  
  def read_config(src='/boot/config',file='.estorm_lotto.conf')
    @config = ParseConfig.new("#{src}/#{file}")
    @config
  end
  
  def parameter(val)
    key=@config[val]
    key
  end
  def group_parameter(grp,val)
    key=nil
    if @config[grp]==nil
      @config.add(grp,{})
    else
      key=@config[grp][val] 
    end
    key
  end
    
  def parameter?(val)
    @config.get_params.include?(val)
  end
  def update_params(params)
     filename=@config.config_file
     file = File.open(filename, 'w')
     @config.params=params
     @config.write(file)
       file.close
   end
 

   end    # Class
end    #Module