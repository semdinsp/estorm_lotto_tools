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
  def 
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
  def update_kv(key,value)
    osflag=(/darwin/ =~ RUBY_PLATFORM) != nil
    make_config_fs_readable if !osflag
    params=self.config.params
    params[key]=value
    self.update_params(params)
    reset_config_fs if !osflag
  end
  def update_printer(newprinter)
    self.update_printer('printer',newprinter)
  end

   end    # Class
end    #Module