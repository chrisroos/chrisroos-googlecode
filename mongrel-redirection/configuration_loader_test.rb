require 'test/unit'
require 'mocha'
require 'configuration_loader'

class RedirectorConfigurationFilesTest < Test::Unit::TestCase
  
  def test_should_load_configuration_file_for_specific_host
    host = 'www.foo.com'
    
    rules = { host => 'foo.com' }
    config_file_path = File.join(ConfigurationLoader::RULES_PATH, host)
    File.open(config_file_path, 'w') { |file| file.puts(rules.to_yaml) }
    
    params = {'HTTP_X_FORWARDED_HOST' => host}
    request = stub('request', :params => params)
    configuration_loader = ConfigurationLoader.new(request)
    assert_equal rules, configuration_loader.load_rules
  ensure
    File.delete(config_file_path)
  end
  
end