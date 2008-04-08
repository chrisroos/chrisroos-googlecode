require File.join(File.dirname(__FILE__), '..', 'config', 'environment')
require 'article'

attributes = {
  :title => 'National Rail Train Times by SMS (again)',
  :body => DATA.read,
  :guid => '6f82d1cd-59c4-414f-8b35-a3a1d5160e3e',
  :published_at => Time.parse('2008-02-28 17:45:00')
}

if Article.find_by_title(attributes[:title])
  p 'Article already exists, skipping'
else
  Article.create!(attributes)
  p 'Article created'
end

__END__
A while back I "hacked":http://blog.seagul.co.uk/articles/2007/07/24/train-times-by-sms-or-improving-national-rail-enquiries a simple "SMS":http://en.wikipedia.org/wiki/Short_message_service interface onto the "national rail enquiries":http://www.nationalrail.co.uk/ website.  It turned out to be more gimmicky than functional and I left it to die.  Over the past couple of weeks I've found myself, once again, in need of such a service and so spent a couple of hours last night reviving it: making it work, making it simpler and tidying the code.  The previous interface required the source station and destination station as well as the date and time of travel.  The format was very strict (requiring you to use the unique three digit station codes) and, as I found, overly complex (I could never remember what it was).  All I really wanted to do was specify the source and destination stations and get a list of the next few departures/arrival times.

The new interface is simply in the format of SOURCE_STATION to DESTINATION_STATION.  So, to find the next few trains from "Ramsgate":http://en.wikipedia.org/wiki/Ramsgate_railway_station to "London Waterloo East":http://en.wikipedia.org/wiki/Waterloo_East_railway_station we can send the following "direct message":http://help.twitter.com/index.php?pg=kb.page&id=15 to the "natrailenq":http://twitter.com/natrailenq user on "twitter":http://twitter.com

<typo:code>
d natrailenq ramsgate to london waterloo east
</typo:code>

Although you can now use the full station name it will only, currently, work if you know the exact name of the station (so, waterloo east wouldn't work in that above example, but london waterloo east will).  It will still work if you supply the three digit station code.

In order to use this service, you will need to create a twitter account, "follow":http://twitter.com/help/follow the natrailenq user and enable SMS notifications from natrailenq.