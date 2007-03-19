require 'test/unit'
require File.dirname(__FILE__) + '/../lib/uri_sanitizer'

class UriSanitizerTest < Test::Unit::TestCase
  
  def test_should_remove_trailing_slash
    sanitizer = UriSanitizer.new('/my-url/')
    assert_equal '/my-url', sanitizer.path
  end
  
  def test_should_retain_querystring
    sanitizer = UriSanitizer.new('/my-url?my-query=123')
    assert_equal '?my-query=123', sanitizer.querystring
  end
  
  def test_should_not_add_querystring
    sanitizer = UriSanitizer.new('/my-url')
    assert_equal '/my-url', sanitizer.location
  end
  
  def test_should_remove_trailing_slash_and_retain_querystring
    sanitizer = UriSanitizer.new('/my-url/?my-query=123')
    assert_equal '/my-url?my-query=123', sanitizer.location
  end
  
end