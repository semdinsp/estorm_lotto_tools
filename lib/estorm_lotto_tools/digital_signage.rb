require 'socket'

module EstormLottoTools
  class DigitalSignage
    def send_4d_results
      wb=EstormLottoTools::WebJsonData.new
      res=wb.get_lotto_draw('teds-lotto4d','NC8QJCRn5k7y7BoADHqJ')
      data=res["draws"]
      send_results("drawdata/update:",data)
      data
     # puts data
    end
    def send_results(topic,data)
      self.send_udp(topic,data.to_json)
     # puts data
    end
    
    def send_udp(topic,data,port=4444)
      u1 = UDPSocket.new
      addr="localhost"
      u1.send "#{topic}#{data}", 0, addr, port
      puts "sending #{addr} #{port} data: #{topic}#{data} "
    end
    
  end
end