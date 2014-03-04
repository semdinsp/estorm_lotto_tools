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
  def printer
    self.parameter('printer')
  end

   end    # Class
end    #Module