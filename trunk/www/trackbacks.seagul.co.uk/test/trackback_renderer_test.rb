require File.join(File.dirname(__FILE__), 'test_helper')
require 'trackback_renderer'

class TrackbackRendererTest < Test::Unit::TestCase
  
  def setup
    received_at = Time.local('2008', '01', '01', '08', '00')
    trackback = { 'received_at' => received_at }
    @renderer = TrackbackRenderer.new(trackback)
  end
  
  def test_should_strip_leading_zeros_from_the_hour_and_append_the_am_or_pm_suffix
    assert_equal '8am', @renderer.received_at
  end
  
  def test_should_return_the_full_weekday_name_and_day_with_suffix_and_full_month_name
    assert_equal 'Tuesday 1st January', @renderer.received_on
  end
  
end