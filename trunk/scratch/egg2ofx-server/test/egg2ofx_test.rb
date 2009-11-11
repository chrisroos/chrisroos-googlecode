require File.join(File.dirname(__FILE__), 'test_helper')

class Egg2OfxServerTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_should_display_introductory_text
    get '/'
    assert_match /egg2ofx/, last_response.body
  end
  
end