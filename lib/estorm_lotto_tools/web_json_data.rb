require 'json'
require 'hurley'
require 'socket'
module EstormLottoTools
  class WebJsonData
    def client_get(url,action,token,email) 
      client = Hurley::Client.new  url
      res="Unknown "
      begin
       res=client.get(action)  do |req|
         req.query["auth_email"] = email
         req.query["auth_token"] = token
       end  #FIX   
     rescue Exception => e
       res=res+ e.message
     end
       res
    end
    def build_response(res)
      json_resp = {:success => false}.to_json
      json_resp =res.body.to_s if !res.is_a?(String) and res.success?
      msg=JSON.parse(json_resp) 
      msg
    end
    def build_host(host)
      "https://#{host}.herokuapp.com/mathematica/"
    end
    def manage_data(host,token,email,action)
      res=self.client_get( build_host(host),action,token,email)
      build_response(res)
    end
    def get_lotto_draw(host,token,email="api@estormtech.com")
     manage_data(host,token,email,"teds_draws?")
    end
    def get_donations_count(host,token,email="api@estormtech.com")
      manage_data(host,token,email,"donations?")
    end
    def get_donators_list(host,token,email="api@estormtech.com")
      manage_data(host,token,email,"donator_list?")
    end
  end
   
end