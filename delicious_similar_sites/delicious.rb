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

class RelatedSites
  attr_reader :bookmark
  def initialize(bookmark)
    @bookmark = bookmark
    @bookmarks = [bookmark.url]
  end
  def related_sites
    @related_sites ||= @bookmark.tags.inject({}) do |hash, tag|
      unless tag =~ /^url\//
        hash[tag] = Delicious.bookmarks(tag, 5).collect do |bookmark|
          next if @bookmarks.include?(bookmark.url)
          @bookmarks << bookmark.url
          bookmark
        end.compact
      end
      hash
    end
  end
end