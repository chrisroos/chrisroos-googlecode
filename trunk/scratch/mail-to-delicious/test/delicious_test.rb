require 'test/unit'
require File.join(File.dirname(__FILE__), '..', 'lib', 'delicious')

module Delicious
  class BookmarkParserHappyPathTest < Test::Unit::TestCase
  
    Email = DATA.read
  
    def setup
      @parser = BookmarkParser.new(Email)
      @parser.parse!
    end
  
    def test_should_extract_the_url
      assert_equal 'http://www.theyworkforyou.com/wrans/?id=2009-02-09e.253765.h', @parser.url
    end
  
    def test_should_extract_the_title
      assert_equal 'This is the title of the post', @parser.title
    end
  
    def test_should_extract_the_notes
      assert_equal 'I wonder if we could solve this at rewiredstate', @parser.notes
    end
  
    def test_should_extract_tags
      assert_equal ['tag1', 'tag2'], @parser.tags
    end
  
  end
  
  class BookmarkParserWithEmptyEmailTest < Test::Unit::TestCase
    
    def setup
      @parser = BookmarkParser.new('')
      @parser.parse!
    end
    
    def test_should_return_an_empty_string_for_the_url
      assert_equal '', @parser.url
    end
    
    def test_should_return_an_empty_string_for_the_title
      assert_equal '', @parser.title
    end
    
    def test_should_return_an_empty_string_for_the_notes
      assert_equal '', @parser.notes
    end
    
    def test_should_return_an_empty_array_for_the_tags
      assert_equal [], @parser.tags
    end
    
  end
  
end

__END__
Received: from wf-out-1314.google.com ([209.85.200.173] helo=wf-out-1314.google.com)
	by coilette.notdot.net with smtp2web (1.0)
	for super-secret-smtp2web-address@smtp2web.com; Tue, 03 Mar 2009 20:51:18 +0000
Received: by wf-out-1314.google.com with SMTP id 24so3528348wfg.13
        for <super-secret-smtp2web-address@smtp2web.com>; Tue, 03 Mar 2009 12:51:17 -0800 (PST)
MIME-Version: 1.0
Received: by 10.142.165.21 with SMTP id n21mr3778269wfe.143.1236113477813; 
	Tue, 03 Mar 2009 12:51:17 -0800 (PST)
Date: Tue, 3 Mar 2009 20:51:17 +0000
Message-ID: <b85742420903031251r5e9eff7as6f41ddd09b4e3d24@mail.gmail.com>
Subject: This is the title of the post
From: Chris Roos <chris@seagul.co.uk>
To: super-secret-smtp2web-address@smtp2web.com
Content-Type: multipart/alternative; boundary=000e0cd17512bf442a04643d1875

--000e0cd17512bf442a04643d1875
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

http://www.theyworkforyou.com/wrans/?id=2009-02-09e.253765.h
T tag1 tag2
I wonder if we could solve this at rewiredstate

--000e0cd17512bf442a04643d1875
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<p><a href="http://www.theyworkforyou.com/wrans/?id=2009-02-09e.253765.h">http://www.theyworkforyou.com/wrans/?id=2009-02-09e.253765.h</a><br>
T tag1 tag2<br>
I wonder if we could solve this at rewiredstate</p>

--000e0cd17512bf442a04643d1875--
