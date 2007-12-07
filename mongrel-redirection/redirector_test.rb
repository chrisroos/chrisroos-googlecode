require 'test/unit'
require 'mocha'
require 'redirector'

class RedirectorTrailingSlashTest < Test::Unit::TestCase
  
  def test_should_redirect_urls_with_trailing_slashes_to_the_equivalent_url_without_a_trailing_slash
    params = {'REQUEST_PATH' => '/path-with-trailing-slash/', 'REQUEST_URI' => '/path-with-trailing-slash/'}
    request = stub('request', :params => params)
    redirector = Redirector.new(request)
    
    assert_equal '/path-with-trailing-slash', redirector.redirect_to
  end
  
  def test_should_redirect_urls_with_trailing_slashes_and_querystring_to_the_equivalent_url_without_a_trailing_slash
    params = {'REQUEST_PATH' => '/path-with-trailing-slash-and-querystring/', 'REQUEST_URI' => '/path-with-trailing-slash-and-querystring/?foo=bar'}
    request = stub('request', :params => params)
    redirector = Redirector.new(request)
    
    assert_equal '/path-with-trailing-slash-and-querystring?foo=bar', redirector.redirect_to
  end
  
  def test_should_not_redirect_the_root_url_or_we_would_end_up_with_infinite_redirections
    params = {'REQUEST_PATH' => '/', 'REQUEST_URI' => '/'}
    request = stub('request', :params => params)
    redirector = Redirector.new(request)
    
    assert_nil redirector.redirect_to
  end
  
  def test_should_not_redirect_the_root_url_even_when_we_have_a_querystring_or_we_would_end_up_with_infinite_redirections
    params = {'REQUEST_PATH' => '/', 'REQUEST_URI' => '/?foo=bar'}
    request = stub('request', :params => params)
    redirector = Redirector.new(request)
    
    assert_nil redirector.redirect_to
  end
  
  def test_should_not_redirect_urls_without_trailing_slashes
    params = {'REQUEST_PATH' => '/path-without-trailing-slash', 'REQUEST_URI' => '/path-without-trailing-slash'}
    request = stub('request', :params => params)
    redirector = Redirector.new(request)
    
    assert_nil redirector.redirect_to
  end
  
  def test_should_not_redirect_urls_without_trailing_slashes_even_when_we_have_a_querystring
    params = {'REQUEST_PATH' => '/path-without-trailing-slash', 'REQUEST_URI' => '/path-without-trailing-slash?foo=bar'}
    request = stub('request', :params => params)
    redirector = Redirector.new(request)
    
    assert_nil redirector.redirect_to
  end
  
end

class RedirectorHostRedirectionTest < Test::Unit::TestCase
  
  def setup
    @params = {'HTTP_X_FORWARDED_HOST' => 'www.foo.com', 'REQUEST_PATH' => '/'}
    @host_redirection_rules = {'www.foo.com' => 'foo.com'}
  end
  
  def test_should_redirect_to_a_different_host
    request = stub('request', :params => @params)
    redirector = Redirector.new(request, @host_redirection_rules)
    
    assert_equal 'http://foo.com', redirector.redirect_to
  end
  
  def test_should_redirect_to_the_new_host_with_the_path_from_the_original_request
    @params['REQUEST_URI'] = '/foo'
    request = stub('request', :params => @params)
    redirector = Redirector.new(request, @host_redirection_rules)
    
    assert_equal 'http://foo.com/foo', redirector.redirect_to
  end
  
  def test_should_redirect_to_the_new_host_with_the_path_and_querystring_from_the_original_request
    @params['REQUEST_URI'] = '/foo?bar=baz'
    request = stub('request', :params => @params)
    redirector = Redirector.new(request, @host_redirection_rules)
    
    assert_equal 'http://foo.com/foo?bar=baz', redirector.redirect_to
  end
  
  def test_should_not_fail_if_not_host_header_is_specified
    @params.delete('HTTP_X_FORWARDED_HOST')
    request = stub('request', :params => @params)
    redirector = Redirector.new(request, @host_redirection_rules)
    
    assert_nil redirector.redirect_to
  end
  
end

class RedirectorHostAndPathRedirectionTest < Test::Unit::TestCase
  
  def test_should_redirect_to_the_new_path_when_host_and_path_match_in_the_rules
    params = {'HTTP_X_FORWARDED_HOST' => 'foo.com', 'REQUEST_PATH' => '/bar'}
    redirection_rules = {'foo.com' => {'/bar' => '/baz'}}
    request = stub('request', :params => params)
    redirector = Redirector.new(request, redirection_rules)
    
    assert_equal '/baz', redirector.redirect_to
  end
  
  def test_should_not_redirect_when_the_host_matches_but_none_of_the_paths_match
    params = {'HTTP_X_FORWARDED_HOST' => 'foo.com', 'REQUEST_PATH' => '/'}
    redirection_rules = {'foo.com' => {'/bar' => '/baz'}}
    request = stub('request', :params => params)
    redirector = Redirector.new(request, redirection_rules)
    
    assert_nil redirector.redirect_to
  end
  
end