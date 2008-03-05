require File.join(File.dirname(__FILE__), 'test_helper')
require 'trackback_http_request_http_method'

class TrackbackHttpRequestMethodTest < Test::Unit::TestCase
  
  def test_should_be_valid_if_http_method_is_post_as_per_the_spec
    http_request_params = {'REQUEST_METHOD' => 'POST'}
    http_request_method = TrackbackHttpRequest::HttpMethod.new(http_request_params)
    assert http_request_method.valid?
  end
  
  def test_should_not_valid_if_http_method_is_not_post_as_per_the_spec
    http_request_params = {'REQUEST_METHOD' => 'NOT-POST'}
    http_request_method = TrackbackHttpRequest::HttpMethod.new(http_request_params)
    assert ! http_request_method.valid?
  end
  
  def test_should_explain_why_its_not_valid
    http_request_params = {'REQUEST_METHOD' => 'invalid-request-method'}
    http_method = TrackbackHttpRequest::HttpMethod.new(http_request_params)
    http_method.valid?
    assert_equal 'Http Method MUST be POST', http_method.error
  end
  
  def test_should_not_explain_why_its_valid
    http_request_params = {'REQUEST_METHOD' => 'POST'}
    http_method = TrackbackHttpRequest::HttpMethod.new(http_request_params)
    http_method.valid?
    assert_nil http_method.error
  end
  
end