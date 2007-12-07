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
  
  def test_should_return_an_empty_ruleset_if_no_host_is_specified_in_the_request_and_we_therefore_cannot_find_any_suitable_rules
    params = {'HTTP_X_FORWARDED_HOST' => nil}
    request = stub('request', :params => params)
    configuration_loader = ConfigurationLoader.new(request)
    
    assert_equal({}, configuration_loader.load_rules)
  end
  
  def test_should_return_an_empty_ruleset_if_the_host_specified_does_not_have_a_config_file
    params = {'HTTP_X_FORWARDED_HOST' => 'host-without-any-rules'}
    request = stub('request', :params => params)
    configuration_loader = ConfigurationLoader.new(request)
    
    config_file_path = File.join(ConfigurationLoader::RULES_PATH, 'host-without-any-rules')
    assert ! File.exists?(config_file_path)
    assert_equal({}, configuration_loader.load_rules)
  end
  
end