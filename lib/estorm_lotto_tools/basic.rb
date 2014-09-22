module EstormLottoTools
  class BasicConfig < EstormLottoTools::ConfigMgr
   # attr_accessor :randgen, :myrange
   
   def initialize(dir,file)
      if dir!=nil and file!=nil
        self.read_config(dir,file)
      else
        self.read_config
      end
    end
  
  def host
    self.parameter('host')
  end
  def params
    self.config.params
  end
  def identity
    self.parameter('identity')
  end 
  def module(val)
    self.group_parameter('modules',val)
  end 
  def printer
    self.parameter('printer')
  end
  def make_config_fs_readable
    puts "config read"
    system('sudo umount /boot')
    system('sudo mount /dev/mmcblk0p1 /boot -o defaults,noatime -t vfat')
  end
  def reset_config_fs
    puts "config read"
    system('sudo umount /boot')
    system('sudo mount -a')  #based on fstab..
  end
  def manage_filesystem
    osflag=(/darwin/ =~ RUBY_PLATFORM) != nil
    make_config_fs_readable if !osflag
    yield
    reset_config_fs if !osflag
  end
  def update_kv(key,value)
    manage_filesystem {
        params=self.config.params
        params[key]=value
        self.update_params(params)
      }
  end
  def update_group_kv(group,key,value)
    manage_filesystem {
        params=self.config.params
        self.config.add(group,{}) if params[group]==nil
        params=self.config.params
        params[group][key]=value 
        self.update_params(params)
      }
  end
  
  
  def update_printer(newprinter)
    self.update_kv('printer',newprinter)
  end
  def module_mgmt(key,value)
     self.update_group_kv('modules',key,value)
  end
  def enable_module(key)
    self.module_mgmt(key,"visible")
  end
  def disable_module(key)
    self.module_mgmt(key,"hidden")
  end
  def modules
    self.config.add('modules',{}) if self.config.params['modules']==nil
    self.config.params['modules']
  end

   end    # Class
end    #Module