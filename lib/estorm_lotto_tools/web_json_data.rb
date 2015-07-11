require 'json'
require 'hurley'
module EstormLottoTools
  class WebJsonData
    def get_lotto_draw(host,token,email="api@estormtech.com")
      client = Hurley::Client.new "https://#{host}.herokuapp.com/mathematica/get_draws?auth_email=#{email}&auth_token=#{token}"
      res=client.get(@svc) 
      puts "hurley respone is #{res.inspect}"
      json_resp = {:success => false}.to_json
      json_resp =res.body.to_s if res.success?
      msg=JSON.parse(resp) 
      msg
    end
  end
end