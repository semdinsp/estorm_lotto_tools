puts File.dirname(__FILE__)
#require 'estorm_lotto_gem'
require File.dirname(__FILE__) + '/test_helper.rb' 


class EstormLottoToolsTest <  Minitest::Test

  def setup
    @f=  EstormLottoTools::ConfigMgr.new
  end
  
  def test_basic
    assert @f.debug, "should be true"
  end
  def test_parse
     assert @f!=nil, "should be not nil"
     dir=File.dirname(__FILE__)
     file='test.conf'
     assert cf=@f.read_config(dir,file),"could not find #{dir}, #{file}"
     assert !cf.get_params.empty?,"should not be empty"
   end
   def test_param
       dir=File.dirname(__FILE__)
       file='test.conf'
       assert cf=@f.read_config(dir,file),"could not find #{dir}, #{file}"
       assert @f.parameter?('key'), "should have key"
       assert @f.parameter('key')=="value", "response should be value #{@f.parameter('key')}"     
   end
   def test_number
        dir=File.dirname(__FILE__)
        file='test.conf'
        assert cf=@f.read_config(dir,file),"could not find #{dir}, #{file}"
        assert @f.parameter?('number'), "should have number"
        assert @f.parameter('number')=="12345", "response should be value #{@f.parameter('key')}"     
    end
    
    def test_update
          dir=File.dirname(__FILE__)
          file='test.conf'
          assert cf=@f.read_config(dir,file),"could not find #{dir}, #{file}"
          assert @f.parameter?('number'), "should have number"
          params=@f.config.params
          params['testwrite']='testwrite'
          @f.update_params(params)
          assert cf=@f.read_config(dir,file),"could not find #{dir}, #{file}"
          assert @f.parameter('testwrite')=='testwrite', "should have write"
          params=@f.config.params
          params['testwrite']='testread'
          @f.update_params(params)
      end
    
  
  

end
