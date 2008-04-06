require File.join(File.dirname(__FILE__), '..', 'config', 'environment')
require 'article'

attributes = {
  :title => 'Atom (like RSS) feeds for thisiskent.co.uk news stories',
  :body => DATA.read,
  :guid => 'cfe3b7ae-05e5-406a-9dcd-e3a646b9d16c',
  :published_at => Time.parse('2008-02-18 10:00:00')
}

if Article.find_by_title(attributes[:title])
  p 'Article already exists, skipping'
else
  Article.create!(attributes)
  p 'Article created'
end

__END__
I've only recently discovered that thisiskent.co.uk (the website of three of our local newspapers) place their "news content":http://www.thisiskent.co.uk/displayNode.jsp?nodeId=250478&command=newPage online.  Unfortunately they've neglected to provide "RSS":http://en.wikipedia.org/wiki/RSS or "Atom":http://en.wikipedia.org/wiki/Atom_%28standard%29 feeds which means that I don't get to see it (visiting websites is soooo old school).  As I'm kinda interested in reading this news, I've put something together that creates a feed from their news articles.  The feed currently lives at http://seagul.co.uk/thisiskent-thanet.atom although this will probably move in the future.  Feel free to subscribe to the feed and please leave comments if it's not working for you.  I'm currently only interested in the Thanet news section but I'd be happy to produce a feed for other areas if people are interested.

The code's over on "google code":http://chrisroos.googlecode.com/svn/trunk/thisis-rss/ if you want to see how it all works.