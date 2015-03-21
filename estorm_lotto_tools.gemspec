

Gem::Specification.new do |s|
  s.name        = "estorm_lotto_tools"
  s.version     = "0.3.0"
  s.author      = "Scott Sproule"
  s.email       = "scott.sproule@ficonab.com"
  s.homepage    = "http://github.com/semdinsp/estorm_lotto_tools"
  s.summary     = "Estorm lottery tools"
  s.description = "Proprietary tools for estorm" 
  # = ['config_cli.rb']    #should be "name.rb"
  s.files        = Dir["{lib,test}/**/*"] +Dir["bin/*.rb"] + Dir["[A-Z]*"] # + ["init.rb"]
  s.license = 'MIT'
  s.rubyforge_project = s.name
  s.required_rubygems_version = ">= 1.3.4"
  s.add_runtime_dependency 'thor'
  s.add_runtime_dependency 'parseconfig'
  signing_key = File.expand_path('~/.ssh/gem-private_key.pem')

    if File.exist?(signing_key)
      s.signing_key = signing_key
      s.cert_chain  = ['gem-public_cert.pem']
    end

    #gem.files         = `git ls-files`.split($/)
    s.executables   = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
   # gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
    s.require_paths = ["lib"]
end
