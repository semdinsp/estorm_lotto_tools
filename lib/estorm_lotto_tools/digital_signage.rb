require 'socket'

module EstormLottoTools
  class DigitalSignage
    def send_4d_results
      wb=EstormLottoTools::WebJsonData.new
      res=wb.get_lotto_draw('teds-lotto4d','NC8QJCRn5k7y7BoADHqJ')
      data=res["draws"]
      #puts "res is #{res} data to json #{data.to_json}"
      topic="drawdata/update:"
      #structured_data = {}
      # data.each {  |a|  strctured_data << {date: }}
      self.send_udp(topic,data.to_json)
     # puts data
    end
    
    def send_udp(topic,data)
      u1 = UDPSocket.new
      addr="localhost"
      port= 4444
      u1.send "#{topic}#{data}", 0, addr, 4444
      puts "sending #{addr} #{port} data: #{topic}#{data} "
    end
    
  end
end