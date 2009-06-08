require File.join(File.dirname(__FILE__), '..', 'test_helper')

class DomainTest < ActiveSupport::TestCase
  
  def test_should_be_created_in_the_new_state
    domain = Domain.create!(:domain => 'example.com')
    assert_equal 'new', domain.state
  end
  
  def test_should_tell_the_url_normaiser_to_normalise_our_domain
    domain = Domain.create!(:domain => 'www.example.com')
    DomainUrlNormaliser.expects(:normalise).with(domain)
    domain.normalise!
  end
  
  def test_should_update_the_url_with_the_value_returned_from_the_url_normaliser
    domain = Domain.create!(:domain => 'www.example.com')
    DomainUrlNormaliser.stubs(:normalise).with(domain).returns('example.com')
    domain.normalise!
    assert_equal 'example.com', domain.domain
  end
  
  def test_should_hash_the_domain_once_its_been_normalised
    domain = Domain.create!(:domain => 'www.example.com')
    DomainUrlNormaliser.stubs(:normalise).with(domain).returns('example.com')
    domain.normalise!
    assert_equal MD5.md5('example.com').to_s, domain.domain_hash
  end
  
  def test_should_update_the_state_once_the_domain_has_been_hashed
    domain = Domain.create!(:domain => 'www.example.com')
    DomainUrlNormaliser.stubs(:normalise)
    domain.normalise!
    assert_equal 'normalised', domain.state
  end
  
end