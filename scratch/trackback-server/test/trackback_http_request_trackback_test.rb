require File.join(File.dirname(__FILE__), 'test_helper')
require 'trackback_http_request_trackback'

class TrackbackHttpRequestTrackbackTest < Test::Unit::TestCase
  
  def test_should_add_the_time_that_we_received_this_trackback_to_the_attributes
    trackback_received_at = Time.now
    Time.stubs(:now).returns(trackback_received_at)
    trackback = TrackbackHttpRequest::Trackback.new({})
    assert_equal trackback_received_at, trackback.to_hash['received_at']
  end
  
  def test_should_be_valid_if_the_permalink_of_the_referring_post_is_present_as_per_the_spec
    trackback_params = {'url' => 'permalink-of-referring-post'}
    trackback = TrackbackHttpRequest::Trackback.new(trackback_params)
    assert trackback.valid?
  end
  
  def test_should_not_be_valid_if_the_permalink_of_the_referring_post_is_not_present_as_per_the_spec
    trackback = TrackbackHttpRequest::Trackback.new({})
    assert ! trackback.valid?
  end
  
  def test_should_explain_why_its_not_valid
    trackback = TrackbackHttpRequest::Trackback.new({})
    trackback.valid?
    assert_equal "You MUST send the URL of your post (permalink) that mentions this post.", trackback.error
  end
  
  def test_should_not_explain_why_its_valid
    trackback_params = {'url' => 'permalink-of-referring-post'}
    trackback = TrackbackHttpRequest::Trackback.new(trackback_params)
    trackback.valid?
    assert_nil trackback.error
  end
  
  def test_should_expose_the_trackback_attributes_as_a_hash_as_thats_what_our_template_currently_expects
    trackback_params = {'key_1' => 'valud_1', 'key_2' => 'value_2'}
    trackback = TrackbackHttpRequest::Trackback.new(trackback_params)
    trackback_hash = trackback.to_hash
    assert_equal trackback_params['key_1'], trackback_hash.delete('key_1')
    assert_equal trackback_params['key_2'], trackback_hash.delete('key_2')
    assert_not_nil trackback_hash.delete('received_at'), "Expected received_at to have been set"
    assert trackback_hash.empty?, "Expected trackback_hash to be empty now that we've deleted all attributes"
  end
  
  def test_should_construct_a_trackback_with_the_attributes_parsed_from_the_http_request_by_the_http_body
    http_request = stub('http_request', :body => stub('body', :read => 'http_body_content'))
    http_body = stub('http_body', :to_hash => 'attributes_from_http_body')
    HttpBody.expects(:new).with('http_body_content').returns(http_body)
    TrackbackHttpRequest::Trackback.expects(:new).with('attributes_from_http_body')
    TrackbackHttpRequest::Trackback.from_http_request(http_request)
  end
  
end