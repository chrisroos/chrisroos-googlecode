require File.join(File.dirname(__FILE__), 'config', 'environment')

bookmarked_urls = eval(DATA.read)
bookmarked_urls.each do |bookmarked_url_attrs|
  bookmarked_url_attrs['url_hash'] = bookmarked_url_attrs.delete('hash')
  Url.create!(bookmarked_url_attrs)
end
__END__
[
  {"title"=>"In memory sqlite database for rails testing - Chris Roos", "hash"=>"a2728cc4f62f7aa8b51b47bba9949702", "url"=>"http://chrisroos.co.uk/blog/2006-02-08-in-memory-sqlite-database-for-rails-testing", "total_posts"=>6, "top_tags"=>{"rails"=>2, "sqlite"=>3, "rubyonrails"=>2, "testing"=>3}},
  {"title"=>"Converting Egg Credit Card Statements to Ofx (for upload to wesabe) - Chris Roos", "hash"=>"6c02f86b3b4de477e1f224367d19061c", "url"=>"http://chrisroos.co.uk/blog/2007-04-01-converting-egg-credit-card-statements-to-ofx-for-upload-to-wesabe", "total_posts"=>1, "top_tags"=>[]},
  {"title"=>"Welcome - Chris Roos", "hash"=>"a7552c35a289530fd9fd37628c345b78", "url"=>"http://chrisroos.co.uk/", "total_posts"=>1, "top_tags"=>[]},
  {"title"=>"Set background transparency in GIMP - Chris Roos", "hash"=>"8347949043f229857cc7622022ae0934", "url"=>"http://chrisroos.co.uk/blog/2005-09-09-set-background-transparency-in-gimp", "total_posts"=>1, "top_tags"=>[]},
  {"title"=>"Turning Off My National Rail Twitter Bot", "hash"=>"da58ec172ec34bcc59728635acf2a68a", "url"=>"http://chrisroos.co.uk/blog/2009-01-31-turning-off-my-national-rail-twitter-bot", "total_posts"=>1, "top_tags"=>[]},
  {"title"=>"A Utility to Manage Apache Virtual Hosts on a Mac (Like the Passenger Pref Pane but for Simple Static Sites) - Chris Roos", "hash"=>"e958be7a8e3fac3138f2305696805e3c", "url"=>"http://chrisroos.co.uk/blog/2008-12-15-a-utility-to-manage-apache-virtual-hosts-on-a-mac-like-the-passenger-pref-pane-but-for-simple-static-sites", "total_posts"=>1, "top_tags"=>[]},
  {"title"=>"Converting Google Code Wiki Content to Html - Chris Roos", "hash"=>"1c1af05a26ce760081cfcfc51c7f4eb0", "url"=>"http://chrisroos.co.uk/blog/2008-07-30-converting-google-code-wiki-content-to-html", "total_posts"=>1, "top_tags"=>[]},
  {"title"=>"Connecting to gmail with Ruby (or Connecting to POP3 servers over SSL with Ruby) - deferred until inspiration hits", "hash"=>"22b899acaa2b8ab22e8588ca039db4e8", "url"=>"http://chrisroos.co.uk/blog/2006-10-24-connecting-to-gmail-with-ruby-or-connecting-to-pop3-servers-over-ssl-with-ruby", "total_posts"=>5, "top_tags"=>{"gmail"=>2, "ruby"=>3}},
  {"title"=>"Crappy ruby script to download photos from a flickr photoset - Chris Roos", "hash"=>"2d99e72305a5c9e699807b3bd859b795", "url"=>"http://chrisroos.co.uk/blog/2006-12-10-crappy-ruby-script-to-download-photos-from-a-flickr-photoset", "total_posts"=>1, "top_tags"=>[]},
  {"title"=>"Fun with Selenium - Chris Roos", "hash"=>"759b36fd78638a0700f718aa345a2f5d", "url"=>"http://chrisroos.co.uk/blog/2007-11-27-fun-with-selenium", "total_posts"=>1, "top_tags"=>[]},
  {"title"=>"Cross browser (well, IE 6, Firefox 2 and Safari 3) bookmarklet script - Chris Roos", "hash"=>"1da4b1a79c8fa7201d34b044ebeb6f1c", "url"=>"http://chrisroos.co.uk/blog/2007-12-14-cross-browser-well-ie-6-firefox-2-and-safari-3-bookmarklet-script", "total_posts"=>1, "top_tags"=>[]},
  {"title"=>"OCR on the Mac with Tesseract - deferred until inspiration hits", "hash"=>"595817508d6e2ce1f70324547c0802b6", "url"=>"http://chrisroos.co.uk/blog/2008-12-02-ocr-on-the-mac-with-tesseract", "total_posts"=>1, "top_tags"=>[]}
]