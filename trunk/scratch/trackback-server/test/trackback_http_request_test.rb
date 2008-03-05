require File.join(File.dirname(__FILE__), 'test_helper')
require 'trackback_http_request'

class TrackbackHttpRequestTest < Test::Unit::TestCase
  
  def test_should_be_valid_if_both_content_type_and_http_method_are_as_per_the_spec
    http_method = stub('http_method', :valid? => true)
    http_content_type = stub('http_content_type', :valid? => true)
    TrackbackHttpRequest::HttpMethod.stubs(:new).returns(http_method)
    TrackbackHttpRequest::HttpContentType.stubs(:new).returns(http_content_type)
    http_request = stub('http_request', :params => {})
    trackback_http_request = TrackbackHttpRequest.new(http_request)
    assert trackback_http_request.valid?
  end
  
  def test_should_not_be_valid_if_http_method_is_not_as_per_the_spec
    TrackbackHttpRequest::HttpMethod.stubs(:valid?).returns(false)
    TrackbackHttpRequest::HttpContentType.stubs(:valid?).returns(true)
    http_request = stub('http_request', :params => {})
    trackback_http_request = TrackbackHttpRequest.new(http_request)
    assert ! trackback_http_request.valid?
  end
  
  def test_should_not_be_valid_if_content_type_is_not_as_per_the_spec
    TrackbackHttpRequest::HttpMethod.stubs(:valid?).returns(true)
    TrackbackHttpRequest::HttpContentType.stubs(:valid?).returns(false)
    http_request = stub('http_request', :params => {})
    trackback_http_request = TrackbackHttpRequest.new(http_request)
    assert ! trackback_http_request.valid?
  end
  
  def test_should_collect_errors_from_http_method_and_http_content_type_validators
    http_method = stub('http_method', :valid? => false, :error => 'http-method-error')
    http_content_type = stub('http_content_type', :valid? => false, :error => 'http-content-type-error')
    TrackbackHttpRequest::HttpMethod.stubs(:new).returns(http_method)
    TrackbackHttpRequest::HttpContentType.stubs(:new).returns(http_content_type)
    http_request = stub('http_request', :params => {})
    trackback_http_request = TrackbackHttpRequest.new(http_request)
    trackback_http_request.valid?
    assert_equal ['http-method-error', 'http-content-type-error'], trackback_http_request.errors
  end

end

class TrackbackHttpRequestIntegrationTest < Test::Unit::TestCase
  
  def test_should_be_valid_and_not_report_any_errors
    http_params = {
      'REQUEST_METHOD' => 'POST',
      'HTTP_CONTENT_TYPE' => 'application/x-www-form-urlencoded'
    }
    http_request = stub('http_request', :params => http_params)
    trackback_http_request = TrackbackHttpRequest.new(http_request)
    assert trackback_http_request.valid?
    assert trackback_http_request.errors.empty?
  end
  
end