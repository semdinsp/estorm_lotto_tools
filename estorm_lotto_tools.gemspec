Gem::Specification.new do |s|
  s.name        = "estorm_lotto_tools"
  s.version     = "0.1.7"
  s.author      = "Scott Sproule"
  s.email       = "scott.sproule@ficonab.com"
  s.homepage    = "http://github.com/semdinsp/estorm_lotto_tools"
  s.summary     = "Estorm lottery tools"
  s.description = "Proprietary tools for estorm" 
  s.executables = ['config_cli.rb']    #should be "name.rb"
  s.files        = Dir["{lib,test}/**/*"] +Dir["bin/*.rb"] + Dir["[A-Z]*"] # + ["init.rb"]
  s.require_path = "lib"
  s.license = 'MIT'
  s.rubyforge_project = s.name
  s.required_rubygems_version = ">= 1.3.4"
  s.add_runtime_dependency 'thor'
  s.add_runtime_dependency 'parseconfig'
end
