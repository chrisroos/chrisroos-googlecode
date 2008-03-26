require File.join(File.dirname(__FILE__), 'test_helper')
require 'weekday_suffix'
require 'erb'
require 'trackback_renderer'
require 'hpricot'

TEMPLATE_DIRECTORY = File.join(File.dirname(__FILE__), '..', 'templates')

class TrackbacksListingTest < Test::Unit::TestCase
  
  def test_should_render_ok_when_only_the_required_trackback_data_is_supplied
    trackback = {
      'blog_name' => nil,
      'url' => 'url',
      'received_at' => Time.now,
      'title' => nil,
      'excerpt' => nil
    }
    trackbacks = [trackback]
    template = File.open(File.join(TEMPLATE_DIRECTORY, 'trackbacks.html.erb')) { |f| f.read }
    erb = ERB.new(template)
    rendered_template = erb.result(binding)
    
    doc = Hpricot(rendered_template)
    
    assert_equal 'url', (doc/'a.trackbackPermalink').first.attributes['href']
    assert_equal 'nofollow', (doc/'a.trackbackPermalink').first.attributes['rel']
    assert_equal 'Anonymous', (doc/'a.trackbackPermalink').first.innerText
    assert (doc/'p.trackbackTitle').empty?
    assert (doc/'p.trackbackExcerpt').empty?
  end
  
end