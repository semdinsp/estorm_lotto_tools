module EstormLottoTools
  class BasicConfig < EstormLottoTools::ConfigMgr
   # attr_accessor :randgen, :myrange
   def initialize
     self.read_config
   end
   def initialize(dir,file)
      self.read_config(dir,file)
    end
  def host
    self.parameter('host')
  end
  
  def identity
    self.parameter('identity')
  end

   end    # Class
end    #Module