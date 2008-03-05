require File.join(File.dirname(__FILE__), 'test_helper')
require 'trackback_http_request_http_content_type'

class TrackbackHttpRequestContentTypeTest < Test::Unit::TestCase
  
  def test_should_be_valid_if_http_content_type_is_url_encoded_as_per_the_trackback_spec
    http_request_params = {'HTTP_CONTENT_TYPE' => 'application/x-www-form-urlencoded'}
    http_content_type = TrackbackHttpRequest::HttpContentType.new(http_request_params)
    assert http_content_type.valid?
  end
  
  def test_should_be_valid_if_http_content_type_is_url_encoded_and_specifies_the_character_set_as_per_the_trackback_spec
    http_request_params = {'HTTP_CONTENT_TYPE' => 'application/x-www-form-urlencoded; charset=utf-8'}
    http_content_type = TrackbackHttpRequest::HttpContentType.new(http_request_params)
    assert http_content_type.valid?
  end
  
  def test_should_not_be_valid_if_http_content_type_is_not_url_encoded_as_per_the_trackback_spec
    http_request_params = {'HTTP_CONTENT_TYPE' => 'not-x-www-form-urlencoded'}
    http_content_type = TrackbackHttpRequest::HttpContentType.new(http_request_params)
    assert ! http_content_type.valid?
  end
  
  def test_should_explain_why_its_not_valid
    http_request_params = {'HTTP_CONTENT_TYPE' => 'invalid-http-content-type'}
    http_content_type = TrackbackHttpRequest::HttpContentType.new(http_request_params)
    http_content_type.valid?
    assert_equal "Content-Type MUST be 'application/x-www-form-urlencoded' with OPTIONAL character encoding", http_content_type.error
  end
  
  def test_should_not_explain_why_its_valid
    http_request_params = {'HTTP_CONTENT_TYPE' => 'application/x-www-form-urlencoded; charset=utf-8'}
    http_content_type = TrackbackHttpRequest::HttpContentType.new(http_request_params)
    http_content_type.valid?
    assert_nil http_content_type.error
  end
  
end