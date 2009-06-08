require File.join(File.dirname(__FILE__), '..', 'test_helper')

class DomainUrlNormaliserTest < Test::Unit::TestCase
  
  def test_should_prepend_missing_http_to_url
    domain = Domain.new(:domain => 'example.com/')
    assert_equal 'http://example.com/', DomainUrlNormaliser.normalise(domain)
  end
  
  def test_should_not_prepend_http_if_it_is_already_present
    domain = Domain.new(:domain => 'http://example.com/')
    assert_equal 'http://example.com/', DomainUrlNormaliser.normalise(domain)
  end
  
  def test_should_append_a_trailing_slash_if_not_present
    domain = Domain.new(:domain => 'http://example.com')
    assert_equal 'http://example.com/', DomainUrlNormaliser.normalise(domain)
  end
  
end