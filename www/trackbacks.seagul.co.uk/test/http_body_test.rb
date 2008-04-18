require File.join(File.dirname(__FILE__), 'test_helper')
require 'http_body'

class HttpBodyTest < Test::Unit::TestCase
  
  def test_should_unescape_data_in_the_http_body
    http_body = HttpBody.new('key=escaped%20value')
    expected_data = {'key' => 'escaped value'}
    assert_equal expected_data, http_body.to_hash
  end
  
  def test_should_handle_empty_values
    http_body = HttpBody.new('key=')
    expected_data = {'key' => ''}
    assert_equal expected_data, http_body.to_hash
  end
  
end