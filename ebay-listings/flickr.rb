require 'hpricot'
require 'net/http'

class Photos
  def self.get(tag)
    new(tag).photos
  end
  def initialize(tag)
    @tag = tag
  end
  def photos
    return [] unless @tag
    (doc/'td#GoodStuff'/'p.UserTagList'/'a').collect do |anchor|
      url = anchor.attributes['href']
      thumbnail_url = (anchor/'img').first.attributes['src']
      {:url => url, :thumbnail_url => thumbnail_url}
    end
  end
private
  def doc
    Hpricot(html)
  end
  def html
    Net::HTTP.get(url)
  end
  def url
    URI.parse("http://www.flickr.com/photos/chrisjroos/tags/#{@tag}/")
  end
end
