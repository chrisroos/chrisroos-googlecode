require 'helpers/test_helper'

class HttpClientTest < Test::Unit::TestCase
  
  def test_should_have_default_headers
    expected_http_headers = { 'User-Agent' => 'MicroID verifier', 'From' => 'you@yoursite.com' }
    assert_equal expected_http_headers, HttpClient.new.http_headers
  end
  
  def test_should_use_net_http_to_get_html
    http_response = Object.new
    http_response.define_instance_method(:body) { __log__ << 'body' }
    net_http = Object.new
    net_http.define_instance_method(:get) { |path, headers| __log__ << "get(#{path}, #{headers})"; http_response }
    net_http_class = Object.new
    net_http_class.define_instance_method(:new) { |host, port| __log__ << "new(#{host}, #{port})"; net_http }
    
    url = 'http://localhost:8080/examples/micro_id.htm'
    http_client = HttpClient.new
    http_client.get_html(url, net_http_class)
    
    uri = URI.parse(url)
    host = uri.host
    port = uri.port
    path = uri.path
    
    assert_equal ["new(#{host}, #{port})"], net_http_class.__log__
    assert_equal ["get(#{path}, #{http_client.http_headers})"], net_http.__log__
    assert_equal ['body'], http_response.__log__
  end
  
  def test_should_split_url_into_host_and_port_and_path_components
    url = 'http://localhost:8080/path/page.htm'
    uri = URI.parse(url)
    expected_host = uri.host
    expected_port = uri.port
    expected_path = uri.path
    
    http_client = HttpClient.new
    
    assert_equal [expected_host, expected_port, expected_path], http_client.host_port_and_path(url)
  end
  
end