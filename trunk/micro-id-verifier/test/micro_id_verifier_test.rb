require 'helpers/test_helper'

class MicroIdVerifierTest < Test::Unit::TestCase
  
  attr_reader :micro_id
  def setup
    @micro_id = 'missing_micro_id'
  end
  
  def test_should_not_verify_missing_micro_id
    html = ''
    
    verifier = MicroIdVerifier.new
    assert !verifier.verify(html, micro_id)
  end
  
  def test_should_verify_micro_id_found_in_head
    html = "<html><head><meta name='microid' content='#{micro_id}'></head><body></body></html>"
    
    verifier = MicroIdVerifier.new
    assert verifier.verify(html, micro_id)
  end
  
  def test_should_not_verify_incorrect_micro_id
    html = "<html><head><meta name='microid' content='#{micro_id}_new'></head><body></body></html>"
    
    verifier = MicroIdVerifier.new
    assert ! verifier.verify(html, micro_id)
  end
  
end