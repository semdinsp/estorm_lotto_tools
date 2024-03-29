require 'hwid'
module EstormLottoTools
  class Files
    def get_filename(dir,name)
      "#{dir}/#{name}"
    end
    
    def self.get_filename(dir,name)
      "#{dir}/#{name}"
    end
    
    def change_hostname(newhost)
        cmd="hostname"
        old=`#{cmd}`.chomp
        ["/etc/hostname","/etc/hosts"].each {  |filename| 
             cmd="sudo sed -i.bak s/#{old}/#{newhost}/g #{filename}"
             puts "changing hostname to: #{newhost} from: #{old} cmd: #{cmd} updated #{filename}"
             system(cmd)
         }
        cmd="sudo /etc/init.d/hostname.sh"
        system(cmd)
        puts "ran hostname.sh  cmd: #{cmd}"
        puts "hostname changed to #{newhost} from: #{old} please reboot"
    end
    
    def force_set_hostname(newhost)
      cmd = "echo #{newhost} > /etc/hostname"
      puts "running cmd '#{cmd}'"
      system(cmd)
      self.write_file("/etc","hosts",self.default_hosts_file(newhost))
      puts "updated hosts file with: [#{self.default_hosts_file(newhost)}]"
    end
    
    def  self.check_prior_change_hostname(newhost)
      wb=EstormLottoTools::Files.new
      cmd="hostname"
      old=`#{cmd}`
      flag= old.chomp==newhost
      if flag
        puts "warning: new hostname and old hostname same: #{old.chomp} #{newhost}"
      else
         wb.change_hostname(newhost)  
      end
      
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
    def self.fix_chromium_locks
      dir="/home/pi/.config/chromium"
      puts "fixing chromium lock files"
      alist=["SingletonLock","SingletonSocket","SingletonCookie"]
      alist.each {  |li|
        EstormLottoTools::Files.delete_if_exists(dir,li)
        EstormLottoTools::Files.delete_symlnk_if_exists(dir,li) 
      }
     
    end
    
    def self.delete_if_exists(dir,name)
        puts "----> deleting if exists: #{self.get_filename(dir,name)}"
        File.delete(self.get_filename(dir,name)) if File.exists?(self.get_filename(dir,name))
    end
    def self.delete_symlnk_if_exists(dir,name)
        puts "----> deleting symlink if exists: #{self.get_filename(dir,name)}"
        File.unlink(self.get_filename(dir,name)) if File.symlink?(self.get_filename(dir,name))
    end
    
    def write_from_web_if_new(url,dir,name)
        self.write_from_web(url,dir,name) if !File.exists?(self.get_filename(dir,name))
    end
    
    # drop actions here needed at boot
    def boot_actions
      puts "teds: starting boot services #{Time.now} Ruby Version: #{RUBY_VERSION} "
      EstormLottoTools::Files.fix_chromium_locks
      Gem.loaded_specs.each { |name, spec|
        puts "Gem installed: #{name}:#{spec.version}" if name.start_with?('es')  }
      puts "starting bluetooth configuration"
      @basic = EstormLottoTools::BasicConfig.new(nil,nil)
      self.enable_bt_printer(@basic.get_bluetooth_printer)  if @basic.bt_enabled?
      puts "update hostname if needed to #{@basic.identity} if starts with 'dist'"
      EstormLottoTools::Files.check_prior_change_hostname(@basic.identity) if @basic.identity.start_with?('dist')
    
    end
    def write_bt_expect(device)
      puts "device: #{device }writing: #{self.bluetooth_expect_script(device)}"
      self.write_file("/tmp","bt_expect.expect",self.bluetooth_expect_script(device))
    end
    def enable_bt_printer(device)
      self.write_bt_expect(device)
      system("sudo chmod a+x /tmp/bt_expect.expect")
      system("sudo /tmp/bt_expect.expect")
      system("sudo rfcomm release 0")
      system("sudo rfcomm bind rfcomm0 #{device}")
    end
    def bluetooth_expect_script(device)
    bluescript = <<EOF_BLUE_CMDS
#!/usr/bin/expect
exp_internal 1
spawn "bluetoothctl"
expect "*#"
send "agent on\r"
expect "*registered"
send "default-agent\r"
expect "*successful"
send "trust #{device}\r"
expect "*succeeded"
send "pair #{device}\r"
expect "*PIN code:"
send "0000\r"
expect "*successful"
close
 
EOF_BLUE_CMDS
       bluescript 
    end

    def default_hosts_file(newhost)
      hostsfile = <<EOF_HOSTSFILE
127.0.0.1	localhost
::1		localhost ip6-localhost ip6-loopback
fe00::0		ip6-localnet
ff00::0		ip6-mcastprefix
ff02::1		ip6-allnodes
ff02::2		ip6-allrouters

127.0.1.1	#{newhost}
    
EOF_HOSTSFILE
      hostsfile
      end

    
    def write_countdown_file(dir,name,identity,flag=true)  #flag is used to for testing
      @platform = Hwid.platform
      @ruby_platform = RUBY_PLATFORM
      @counter=85
      @counter =25 if @platform.include?("raspberry 2") or @platform.include?("mac")
      @dist=identity
      #filemgr.write_file('/home/pi/info-beamer-pi/estorm/nodemgr/drawdata'
      cdf=self.countdown_file_contents
      puts "writing  countdown file:  #{self.get_filename(dir,name)} if #{flag} counter: #{@counter} platform: #{@platform}"
      puts "FILE CONTENTS \n #{cdf}" if !flag   #show if debug
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