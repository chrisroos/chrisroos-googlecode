require 'md5'
require 'json'
require 'open-uri'
require 'cgi'

class Delicious
  class << self
    def bookmark_from_url(url)
      bookmark_from_hash(MD5.md5(url))
    end
    def bookmark_from_hash(hash_of_url)
      bookmarks("url/#{hash_of_url}").first
    end
    def bookmarks(tag, count = nil)
      json_url = "http://del.icio.us/feeds/json/chrisjroos/#{tag}?raw"
      json_url += "&count=#{count}" if count
      bookmarks = JSON.parse(open(json_url).read)
      bookmarks.collect { |bookmark| Bookmark.new(bookmark) }
    end
  end
end

class Bookmark
  attr_reader :title, :description, :tags, :url
  def initialize(bookmark)
    @title = bookmark['d']
    @description = CGI.unescapeHTML(bookmark['n'] || '')
    @tags = bookmark['t']
    @url = bookmark['u']
  end
  def ==(bookmark)
    @title == bookmark.title && @description == bookmark.description && @tags == bookmark.tags && @url == bookmark.url
  end
end

class Bookmarks
  class << self
    def similar_to(current_site)
      similar_bookmarks = current_site.tags.collect do |tag|
        Delicious.bookmarks(tag, 5)
      end.flatten.uniq
      new(current_site, *similar_bookmarks)
    end
  end
  attr_reader :current_site
  def initialize(current_site, *bookmarks)
    @current_site = current_site
    unique_bookmarks = []
    bookmarks.each { |b| unique_bookmarks << b unless unique_bookmarks.include?(b) }
    tags_and_bookmarks = unique_bookmarks.collect { |bookmark| [(current_site.tags & bookmark.tags).sort, bookmark] unless current_site == bookmark }.compact
    number_of_tags_and_bookmarks = Hash.new { |hash, key| hash[key] = [] }
    tags_and_bookmarks.each { |(tags, bookmark)| number_of_tags_and_bookmarks[tags.length] << bookmark }
    @tags_and_bookmarks = number_of_tags_and_bookmarks.to_a.reverse
  end
  def each
    @tags_and_bookmarks.each { |tag_and_bookmark| yield tag_and_bookmark }
  end
  def to_a
    @tags_and_bookmarks
  end
end

# bookmark = Delicious.bookmark_from_url("http://uk.techcrunch.com/2007/11/01/crowdstorm-comes-back-but-can-it-cut-it/")
# Bookmarks.similar_to(bookmark).each do |(tags, bookmark)|
#   p [tags, bookmark.url]
# end