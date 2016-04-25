module EstormLottoTools
  class WebClock
    
    def self.clock_get_draw_results(tickettype)
      basic = EstormLottoTools::BasicConfig.new(nil,nil)
      wb=EstormLottoGem::WbDrawResults.new  
  
      wb.set_host(basic.host)
      res=wb.get_results(basic.identity,tickettype) 
      puts "results: #{res.inspect.to_s} basic: #{basic.inspect.to_s}id #{basic.identity} tt: #{tickettype} print #{basic.printer}"  
      [res,wb]
    end

    def self.clock_print_activity(tickettype,msg)
      puts "Starting job: #{msg}"
      begin
        res,wb=EstormLottoTools::WebClock.clock_get_draw_results(tickettype)
        yield(res,wb)
       rescue Exception => e
         puts "Exception in #{msg} #{e.inspect}"
       end 
    end

    def self.clock_action(name)
      basic = EstormLottoTools::BasicConfig.new(nil,nil)
      ['4d'].each { |tickettype|
       # ['4d','3d'].each { |tickettype|
       EstormLottoTools::WebClock.clock_print_activity(tickettype,name) {  |res,wb|   
                 wb.send(name,res.first,basic.identity,tickettype,basic.printer) if res!=nil and res.first!=nil and res.first['success']==true  
                             }
              }     
    end
    
     def self.miscellaneous_action(name)
       puts "Upgrade gems"
       site="www.estormtech.com"
       upgrade_type="background_gems"
       system("curl #{site}/upgrade/#{upgrade_type}.html |  bash  &") 
     end
   
    
  end  # clock
end # module
    