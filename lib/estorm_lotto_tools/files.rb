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
  
  end
end