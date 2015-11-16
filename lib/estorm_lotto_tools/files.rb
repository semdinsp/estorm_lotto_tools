require 'hwid'
module EstormLottoTools
  class Files
    def get_filename(dir,name)
      "#{dir}/#{name}"
    end
    def write_file(dir,name,contents)
      puts "writing file:  #{self.get_filename(dir,name)}"
      File.open(self.get_filename(dir,name), 'w') { |file| file.write(contents) }
    end
    def write_from_web(url,dir,name)
        client = Hurley::Client.new url
        res = client.get()  # may need chunks in future
        self.write_file(dir,name,res.body) if res.success?
    end
    def write_from_web_if_new(url,dir,name)
        self.write_from_web(url,dir,name) if !File.exists?(self.get_filename(dir,name))
    end
    
    def write_countdown_file(dir,name,identity,flag=true)  #flag is used to for testing
      @platform = Hwid.platform
      @ruby_platform = RUBY_PLATFORM
      @counter=80
      @counter =25 if @platform.include?("raspberry 2") or @platform.include?("mac")
      @dist=identity
      #filemgr.write_file('/home/pi/info-beamer-pi/estorm/nodemgr/drawdata'
      cdf=self.countdown_file_contents
      puts "writing  countdown file:  #{self.get_filename(dir,name)} if #{flag} counter: #{@counter} platform: #{@platform}"
      puts "FILE CONTENTS \n #{cdf}"
      self.write_file(dir,name,cdf) if flag
      cdf
    end
    
    def countdown_file_contents
      cdf =  <<ENDFILE.gsub(/^ {6}/, '')
      <!DOCTYPE html>
      <html lang="en">
      <head>
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
      <title></title>
      
      <script type="text/javascript">
      window.onload=function() {
      function countdown() {
      if ( typeof countdown.counter == 'undefined' ) {
          countdown.counter = #{@counter}; // initial count
          }
      if(countdown.counter > 0) {
      	document.getElementById('count').innerHTML = countdown.counter--;
          setTimeout(countdown, 1000);
          }
      else {
          location.href = 'http://localhost:8080/';
          }
      }
      countdown();
      };
      </script>
      
      </head>
      <body>
      <h1>#{@dist.upcase}: Welcome to your TEDS Terminal!</h1>

      <h2>You will be redirected to the TEDS System in </h2>
      <p style="text-align:center;font-size:80px;color:green;"><span id="count"></span> &nbsp; seconds </p>
      <p> This file produced by  system: #{@platform}  on ruby #{@ruby_platform}  </p>
      <p>TEDS is an electronic distribution system which can sell/distribute electronic products such as lottery tickets,process payments and manage domestic money transfers.  The system is currently starting up</p>
      </body>
      </html>

ENDFILE
      cdf
      
    end
  
  end
end