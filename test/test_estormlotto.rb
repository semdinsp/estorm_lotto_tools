puts File.dirname(__FILE__)
#require 'estorm_lotto_gem'
require File.dirname(__FILE__) + '/test_helper.rb' 


class EstormLottoToolsTest <  Minitest::Test

  def setup
    @f=  EstormLottoTools::ConfigMgr.new
    dir=File.dirname(__FILE__)
    file='test.conf'
    @basic = EstormLottoTools::BasicConfig.new(dir,file)
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
      
      def test_update2
            dir=File.dirname(__FILE__)
            file='test.conf'
            assert cf=@basic.read_config(dir,file),"could not find #{dir}, #{file}"
            assert @basic.parameter?('number'), "should have number"
            @basic.update_kv('test2','3456')
            @basic.update_group_kv('testgr','test','456')
            assert cf=@basic.read_config(dir,file),"could not find #{dir}, #{file}"
            assert @basic.parameter('test2')=='3456', "should have write"
            assert @basic.group_parameter('testgr','test')=='456', "should have group write #{cf.inspect} #{@basic.inspect}"
            
            params=@basic.config.params
            params['testwrite']='testread'
            @basic.update_params(params)
        end
        def test_modules
              dir=File.dirname(__FILE__)
              file='test.conf'
              assert cf=@basic.read_config(dir,file),"could not find #{dir}, #{file}"
               @basic.enable_module('fred')
               assert @basic.modules['fred']=='visible', 'module enabled'
            end
    def test_host
      assert @basic.host=='testhost:123', "host wrong #{@basic.inspect}"
      assert @basic.identity=='6590683565', "source wrong #{@basic.inspect}"
      assert @basic.params.include?('host'), "params wrong #{@basic.params}"
    end
    
    def test_shutdown
      params={ 'restart' => 'true'}
      webu=EstormLottoTools::WebUtilities.new
      cmd=webu.shutdown(params['restart']=='true')
      assert cmd.include?('-r'), "cmd wrong #{cmd}"
      params={ 'restart' => 'true'}
      webu=EstormLottoTools::WebUtilities.new
      cmd=webu.shutdown(params['restart']=='false')
      assert cmd.include?('-h'), "cmd wrong #{cmd}"
      cmd=EstormLottoTools::WebUtilities.web_app_shutdown(params)
      assert cmd.include?('-r'), "cmd wrong #{cmd}"
    end
  
  

end
