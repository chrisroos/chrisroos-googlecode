require 'helpers/test_helper'

class MicroIdGeneratorTest < Test::Unit::TestCase
  
  def test_should_hash_email_address_and_url
    email = 'my_email'
    url = 'my_url'
    expected_micro_id = Digest::SHA1.new(Digest::SHA1.new(email).to_s + Digest::SHA1.new(url).to_s).to_s
    micro_id_generator = MicroIdGenerator.new(email, url)
    assert_equal expected_micro_id, micro_id_generator.micro_id
  end
  
end