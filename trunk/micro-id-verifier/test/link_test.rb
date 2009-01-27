require 'helpers/test_helper'

class LinkTestBase < Test::Unit::TestCase
  
  attr_reader :link
  def setup
    @link = Link.new(:url => 'my_url', :expected_micro_id => 'my_micro_id')
  end
  
  def test_should_be_in_unprocessed_state_by_default
    assert_equal LinkStatus::Unprocessed, link.status
  end
  
end

class MockHttpClientTest < LinkTestBase
  
  attr_reader :http_client
  def setup
    super
    @http_client = HttpClient.new
  end
  
  def test_should_use_http_client_to_get_html
    http_client.stub_instance_method(:get_html) { __log__ << 'get_html' }
    link.get_html(http_client)
    assert ['get_html'], http_client.__log__
  end
  
  def test_should_rescue_http_client_errors_as_nil
    http_client.stub_instance_method(:get_html) { raise }
    assert_nil link.get_html(http_client)
  end
  
end

class MockMicroIdVerifierTest < LinkTestBase
  
  attr_reader :micro_id_verifier
  def setup
    super
    @micro_id_verifier = MicroIdVerifier.new
  end
  
  def test_should_ask_micro_id_verifier_to_verify_micro_id
    micro_id_verifier.stub_instance_method(:verify) { |html, micro_id| __log__ << html; __log__ << micro_id }
    
    link.stub_instance_method(:get_html) { 'my_html' }
    link.verify_micro_id!(micro_id_verifier)
    
    assert_equal ['my_html', 'my_micro_id'], micro_id_verifier.__log__
  end
  
  def test_should_be_in_successful_state_if_verification_succeeds
    micro_id_verifier.stub_instance_method(:verify) { true }
    
    link.stub_instance_method(:get_html) { '' }
    link.verify_micro_id!(micro_id_verifier)
    assert_equal LinkStatus::VerificationSuccess, link.status
  end
  
  def test_should_be_in_failure_state_if_verification_fails
    micro_id_verifier.stub_instance_method(:verify) { false }
    
    link.stub_instance_method(:get_html) { '' }
    link.verify_micro_id!(micro_id_verifier)
    assert_equal LinkStatus::VerificationFailure, link.status
  end
  
  def test_should_report_error_status_if_get_html_fails
    link.stub_instance_method(:get_html) { return nil }
    link.verify_micro_id!
    assert_equal LinkStatus::VerificationError, link.status
  end
  
end

class LinkVerificationStatesTest < Test::Unit::TestCase
  
  def test_should_not_override_status_if_previously_set
    link = Link.new(:status => 2)
    assert_equal 2, link.status
  end
  
  def test_should_select_all_unverified_links
    unverified_link = Link.new(:status => 1)
    verified_link = Link.new(:status => 2)
    links = [unverified_link, verified_link]
    
    assert_equal [unverified_link], Link.find_all_unverified(links)
  end
  
  def test_should_verify_only_unverified_links
    unverified_link = Link.new(:status => 1)
    verified_link = Link.new(:status => 2)
    unverified_link.stub_instance_method(:verify_micro_id!) { __log__ << 'verify_micro_id!' }
    verified_link.stub_instance_method(:verify_micro_id!) { raise 'Unexpected method call' }
    links = [unverified_link, verified_link]
    
    Link.verify_all(links)
    assert_equal ['verify_micro_id!'], unverified_link.__log__
  end
  
end

class LinkDatabaseTest < Test::Unit::TestCase
  
  def setup
    Link.destroy_all
  end
  
  def test_should_default_to_finding_all_unverified_links_in_db
    unverified_link = Link.create!
    verified_link = Link.create!(:status => 99)
    
    assert_equal [unverified_link], Link.find_all_unverified
  end
  
  def test_should_default_to_finding_all_unverified_links_in_db_1
    unverified_link = Link.create!
    verified_link = Link.create!(:status => 99)
    
    Link.verify_all
    
    verified_link.reload
    unverified_link.reload
    
    assert_equal 99, verified_link.status
    assert_not_equal 1, unverified_link.status
  end
  
  def test_should_persist_verification_status
    link = Link.create!
    link.verify_micro_id!
    
    link_status = link.status
    link.reload
    
    assert_equal link_status, link.status
  end
  
end