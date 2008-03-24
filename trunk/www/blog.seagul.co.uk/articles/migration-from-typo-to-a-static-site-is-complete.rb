require File.join(File.dirname(__FILE__), '..', 'config', 'environment')
require 'article'

attributes = {
  :title => 'Migration from Typo to a static site is complete',
  :body => DATA.read,
  :guid => 'e26ad0cb-1403-4961-801d-e3192495cc97',
  :published_at => Time.parse('2008-01-23 23:15:34')
}

if Article.find_by_title(attributes[:title])
  p 'Article already exists, skipping'
else
  Article.create!(attributes)
  p 'Article created'
end

__END__
I'm tired so I'll keep this short...  If you can see this post then it means that I haven't broken anything (well, it means I haven't broken the rss feed anyway).  I still have lots to do but "eating my own dogfood":http://en.wikipedia.org/wiki/Eat_one's_own_dog_food should give me a reason to keep improving.