require File.dirname(__FILE__) + '/../test_helper'

require 'dns_mock'

class TrackbackTest < Test::Unit::TestCase
  fixtures :contents, :blogs

  def test_incomplete
    tb = Trackback.new
    tb.blog_name = "Blog name"
    tb.title = "Title"
    tb.excerpt = "Excerpt"

    assert ! tb.save
    assert tb.errors.invalid?('url')

    tb.url = "http://foo.com"
    assert tb.save
    assert tb.errors.empty?
    assert tb.guid.size > 15
    assert !tb.spam?
  end

  def test_reject_spam_rbl
    tb = Trackback.new do |tb|
      tb.blog_name = "Spammer"
      tb.title = "Spammy trackback"
      tb.excerpt = %{This is just some random text. <a href="http://chinaaircatering.com">without any senses.</a>. Please disregard.}
      tb.url = "http://buy-computer.us"
      tb.ip = "212.42.230.206"
    end

    assert tb.spam?
  end

end
