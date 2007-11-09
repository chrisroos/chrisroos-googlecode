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
  alias_method :eql?, :==
  def hash
    "url=#{self.url}".intern.to_i
  end
  def tags_in_common(bookmark)
    @tags & bookmark.tags
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
    bookmarks.each { |bookmark| unique_bookmarks << bookmark unless bookmark == current_site || unique_bookmarks.include?(bookmark) }
    @tags_and_bookmarks = unique_bookmarks.sort_by { |bookmark| current_site.tags_in_common(bookmark).length }.reverse
  end
  def each
    @tags_and_bookmarks.each { |tag_and_bookmark| yield tag_and_bookmark }
  end
end