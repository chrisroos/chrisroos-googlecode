# # require 'net/https'
# # require 'uri'
# # 
# # 
# # url = URI.parse('https://api.del.icio.us')
# # http = Net::HTTP.new(url.host, url.port)
# # http.use_ssl = true
# # http.verify_mode = OpenSSL::SSL::VERIFY_NONE
# # 

HTTP_USERNAME = 'USERNAME'
HTTP_PASSWORD = 'PASSWORD'
# # request = Net::HTTP::Get.new('/v1/posts/all?tag=to_read')
# # request.basic_auth HTTP_USERNAME, HTTP_PASSWORD
# # response = http.request(request)
# # print response.body
#       
# # p unread_items
# # res = Net::HTTP.start(url.host, url.port) {|http|
# #   http.get('/v1/posts/get')
# # }
# # puts res.body
# 
# 
# 
# 
# posts = %%
# <posts update="2006-12-10T10:23:09Z" user="chrisjroos">
#   <post href="http://blog.grayproductions.net/articles/category/the-gateway" description="Shades of Gray - category the-gateway" extended="jegii article about ruby mail to news gateway" hash="739502520bf3b28fb0207f7d22f3436a" tag="to_read ruby" time="2006-12-10T10:23:09Z" />
#   <post href="http://www.nytimes.com/2006/12/03/magazine/03intelligence.html" description="Open-Source Spying - New York Times" extended="open source spying" hash="8966059893152c07d2a9596944613b11" tag="to_read" time="2006-12-10T10:22:23Z" />
#   <post href="http://blogs.zdnet.com/digitalID/?p=78" description="» The case for OpenID | Digital ID World | ZDNet.com" extended="zdnet article on openid" hash="0946b2bde020cd9806cce513299cce56" tag="to_read" time="2006-12-07T07:59:51Z" />
#   <post href="http://bitworking.org/projects/XML2004/presentation/pre.html" description="The Atom Publishing Protocol" extended="2004 Presentation by Joe Gregorio about Atom Publishing Protocol" hash="7b7f7c6c558365a53bb15942a8f69890" tag="atom app presentation to_read" time="2006-12-06T18:41:14Z" />
#   <post href="http://xprogramming.com/xpmag/dbcSimpleDesign.htm" description="Shooting for Simple Design" extended="ron jeffries article on xprogramming.com to read" hash="b6c2c6629df69595f8bf93c7cb05a8f2" tag="to_read" time="2006-11-29T21:35:34Z" />
#   <post href="http://www.economist.com/business/displaystory.cfm?story_id=7138905" description="Internet advertising | The ultimate marketing machine | Economist.com" extended="article about online advertising to read" hash="1f981c96a419ef68ccea30107f7abc45" tag="to_read" time="2006-11-29T21:32:33Z" />
#   <post href="http://www.artima.com/rubycs/articles/ruby_as_dsl.html" description="Creating DSLs with Ruby" hash="ceed19b2220cfd7dccc94a57bb8fca1b" tag="ruby dsl artime to_read" time="2006-03-23T11:30:46Z" />
#   <post href="http://en.wikipedia.org/wiki/Digital_object_identifier" description="Digital object identifier - Wikipedia, the free encyclopedia" hash="ae6d69c760ab710abc2dd89f3937d2f4" tag="urn object identification web to_read" time="2006-02-19T23:27:01Z" />
#   <post href="http://www.cre8d-design.com/blog/2006/01/05/thoughts-on-structured-blogging-and-web-20/" description="Thoughts on structured blogging and Web 2.0 — cre8d design blog" hash="41d3d1e7e22afb47daea0e6c308e271f" tag="structured blogging to_read" time="2006-02-19T23:26:18Z" />
#   <post href="http://www.darcynorman.net/2003/04/25/trackback-vs-pingback" description="Trackback vs. Pingback at D’Arcy Norman Dot Net" hash="51ed1161439d502f55ce8f659b7c4fed" tag="trackback pingback to_read" time="2006-02-19T23:25:52Z" />
#   <post href="http://lunchroom.lunchboxsoftware.com/pages/specifications" description="Specification Classes in Rails" hash="abfe0af5cc930b7343e2b367679338bc" tag="to_read" time="2005-12-20T08:18:39Z" />
#   <post href="http://www.oreillynet.com/pub/a/etel/2005/12/19/hacking-in-asterisk-and-rails.html" description="O'Reilly Network: Hacking Asterisk and Rails with RAGI" hash="5ec4449e08b58585874cb7e115e574a1" tag="ruby rails asterisk to_read" time="2005-12-20T08:14:24Z" />
#   <post href="http://rails.techno-weenie.net/" description="Rails newbie site" hash="3b3cc7e8b1a9bfe9172f749c9bff97cf" tag="rails newbie to_read" time="2005-11-17T14:16:31Z" />
#   <post href="http://bnoopy.typepad.com/bnoopy/2005/03/the_long_tail_o.html" description="long tail of software" hash="159caae3f4cfc283fcedf89397bd9e6c" tag="to_read" time="2005-11-01T14:53:50Z" />
#   <post href="http://savas.parastatidis.name/2005/05/26/e8507db9-b6bc-459d-8735-fd524bd8b7a9.aspx" description="&lt;savas:weblog/&gt; post on REST MEST and more" hash="32d387735f0da8331e4108b94de39b7c" tag="REST MEST to_read" time="2005-06-10T18:09:08Z" />
#   <post href="http://www.exubero.com/junit/antipatterns.html" description="JUnit Anti Patterns" hash="cfc86b8174f8a87cd23548412fc5a89d" tag="tdd unit testing to_read" time="2005-06-10T10:01:58Z" />
#   <post href="http://www.refactoring.be/articles/learing-from-broken-unittests.html" description="Learning from Broken Unit Tests" hash="acd9bfd0f76d76678e1c8db3f958d69e" tag="unit testing to_read" time="2005-06-10T09:45:26Z" />
#   <post href="http://www.bigbold.com/snippets/" description="Code Snippets: Store, sort and share source code, with tag goodness" extended="source at snippets-0.2.tar.gz" hash="68291fdb338df5f03badfbcd7e81d2a6" tag="source code snippets to_read" time="2005-05-27T03:23:33Z" />
#   <post href="http://www.to-done.com/" description="To-Done" hash="2e12b675e709b3d45c62dd4eed8d2af7" tag="to_read" time="2005-05-26T10:47:18Z" />
#   <post href="http://www.testdriven.com/modules/mylinks/visit.php?cid=16&amp;lid=974" description="testdriven.com: Your test-driven development community" extended="Unit testing database code" hash="fb40e74dfb647be96ae29b1cf6e9582f" tag="tdd database unit to_read" time="2005-05-13T18:39:55Z" />
#   <post href="http://www.testdriven.com/modules/mylinks/visit.php?cid=16&amp;lid=976" description="testdriven.com: Your test-driven development community" extended="Unit Testing Database Code" hash="1e3dc55837edafe34e63c9f7fda23761" tag="tdd database to_read" time="2005-05-13T18:39:00Z" />
#   <post href="http://www.testdriven.com/modules/mylinks/visit.php?cid=7&amp;lid=982" description="testdriven.com: Your test-driven development community" extended="Feature-driven development, test-driven development, and test-first programming" hash="0259a2f21d14b9599b70a51c572869f2" tag="tdd to_read" time="2005-05-13T18:37:29Z" />
#   <post href="http://alistair.cockburn.us/crystal/articles/unlmboomp/usingnaturallanguageasametaphoricbase.html" description="Using Natural Language as a Metaphoric Base for Object-Oriented Modeling" hash="046c18bc45418574916eaddf76cee2c8" tag="alistair cockburn oo design to_read" time="2005-05-13T18:30:26Z" />
#   <post href="http://blogs.msdn.com/oldnewthing/archive/2005/01/14/352949.aspx" description="The Old New Thing : Cleaner, more elegant, and harder to recognize" hash="4994fc9d12d90bf9c63804903b8c2d5c" tag="software development exceptions to_read" time="2005-05-11T16:33:49Z" />
#   <post href="http://matt.simerson.net/computing/dns/djbdns-freebsd.shtml" description="djbdns on freebsd" hash="98c945882bb4d7d1251e3af199fe4b2e" tag="djb dns freebsd to_read" time="2005-04-26T20:32:35Z" />
#   <post href="http://sourceforge.net/projects/webadmin/" description="unix web admin interface" hash="2762160017714a6b02c7668c1c2d6dc5" tag="to_read" time="2005-04-26T17:03:12Z" />
#   <post href="http://instiki.org/search/?query=proxy" description="proxy details for instiki" hash="8348821eac3c1b45311c6bc63e548bf3" tag="to_read" time="2005-04-26T17:02:41Z" />
#   <post href="http://www.cs.virginia.edu/~robins/YouAndYourResearch.html" description="You and Your Research" hash="568703e0dcb9452fa6e2a3f594301cbd" tag="to_read" time="2005-04-26T06:51:07Z" />
#   <post href="http://www.artcompsci.org/kali/index.html" description="The Art of Computational Science home page" hash="b3aa9566ae55d714afd67717a20d39fa" tag="ruby to_read" time="2005-04-25T06:04:20Z" />
#   <post href="http://rubyforge.org/projects/pimki/" description="RubyForge: Project Info- Pimki" hash="f9c825ee8b0c4d15a17211802f160b12" tag="to_read" time="2005-04-19T16:56:42Z" />
#   <post href="http://www.testdriven.com/modules/mylinks/visit.php?lid=719" description="testdriven.com: Your test-driven development community" hash="1d641c06248c83ed77874d1241eb0abc" tag="fit to_read" time="2005-04-18T11:26:22Z" />
#   <post href="http://www.intertwingly.net/blog/2005/04/13/Continuations-for-Curmudgeons" description="Sam Ruby: Continuations for Curmudgeons" hash="d92a565d910244cebfcc90665a87aebd" tag="to_read" time="2005-04-18T11:26:09Z" />
#   <post href="http://dotnetjunkies.com/WebLog/jpalermo/archive/2005/03/28/61512.aspx" description="Trying out the Model-View-Presenter pattern - level 300" hash="41e275acf39f8d9edcc8dba04f6f1302" tag="mvp to_read" time="2005-04-15T11:07:40Z" />
#   <post href="http://en.wikipedia.org/wiki/REST" description="Representational State Transfer - Wikipedia, the free encyclopedia" hash="3652f925139be4c1562297337861979a" tag="REST to_read" time="2005-04-15T10:30:30Z" />
#   <post href="http://www.xfront.com/REST-Web-Services.html" description="REST explanation" hash="04bcb354d9bad1a90387a2ec541f19b1" tag="REST web development to_read" time="2005-04-15T10:30:11Z" />
#   <post href="http://www.testdriven.com/modules/mylinks/visit.php?cid=16&amp;lid=950&amp;PHPSESSID=27e4ce2d202e6dae49a371c6f1577f8e" description="testdriven.com: Your test-driven development community" hash="77a86ccbaaf3827025420bcf8a819a80" tag="tdd to_read" time="2005-04-15T10:03:35Z" />
#   <post href="http://www.testdriven.com/modules/mylinks/visit.php?cid=7&amp;lid=951" description="testdriven.com: Your test-driven development community" hash="bca88ac543a19c7695562bdbecf6726c" tag="tdd to_read" time="2005-04-15T10:03:23Z" />
#   <post href="http://www.testdriven.com/modules/mylinks/visit.php?cid=16&amp;lid=953" description="testdriven.com: Your test-driven development community" hash="a62f15c0f2033c81c4e353e5745007e6" tag="tdd to_read" time="2005-04-15T10:03:13Z" />
# </posts>
# %
# 
# unread_post_urls = posts.scan(/post href="(.*?)"/).flatten
# unread_post_urls.each do |url|
#   
# end

require 'rubygems'
require 'rbosa'

# safari = OSA.app('Safari')
# document = safari.make(OSA::Safari::Document)
# document.url = 'http://www.bbc.co.uk'

systems_events = OSA.app('System Events')
p systems_events.processes

# tell application "System Events"
#   tell process "Safari"
#     delay 3
#     click menu item "Print…" of menu "File" of menu bar 1
#     delay 1
#     key down return
#     delay 1
#     key up return
#   end tell
# end tell

# safari.print(document, false, )

# document.url = 'http://www.bbc.co.uk'
# # safari.open('http://www.bbc.co.uk')