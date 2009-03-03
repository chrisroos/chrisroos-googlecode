require 'test/unit'
require File.join(File.dirname(__FILE__), '..', 'lib', 'delicious')

module Delicious
  class BookmarkParserTest < Test::Unit::TestCase
  
    Email = DATA.read
  
    def setup
      @parser = BookmarkParser.new(Email)
      @parser.parse!
    end
  
    def test_should_extract_the_url
      assert_equal 'http://foobar.com', @parser.url
    end
  
    def test_should_extract_the_title
      assert_equal 'test subject', @parser.title
    end
  
    def test_should_extract_the_notes
      assert_equal 'notes', @parser.notes
    end
  
    def test_should_extract_tags
      assert_equal ['t1', 't2'], @parser.tags
    end
  
  end
end
__END__
Received: from rv-out-0506.google.com ([209.85.198.234] helo=rv-out-0506.google.com)
        by coilette.notdot.net with smtp2web (1.0)
        for super-secret-smtp2web-address@smtp2web.com; Tue, 03 Mar 2009 23:42:29 +0000
Received: by rv-out-0506.google.com with SMTP id b25so2913680rvf.31
        for <super-secret-smtp2web-address@smtp2web.com>; Tue, 03 Mar 2009 15:42:28 -0800 (PST)
MIME-Version: 1.0
Received: by 10.142.72.4 with SMTP id u4mr3851526wfa.216.1236123748382; Tue, 
        03 Mar 2009 15:42:28 -0800 (PST)
Date: Tue, 3 Mar 2009 23:42:28 +0000
Message-ID: <b85742420903031542s4c610b18v92e1d23a5155276a@mail.gmail.com>
Subject: test subject
From: Chris Roos <chris@seagul.co.uk>
To: super-secret-smtp2web-address@smtp2web.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

http://foobar.com
T t1 t2
notes