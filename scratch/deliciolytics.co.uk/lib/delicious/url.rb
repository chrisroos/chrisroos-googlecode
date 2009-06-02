require 'json'
require 'net/http'

module Delicious
  class Url
    def initialize(url_hash)
      @url_hash = url_hash
    end
    def urlinfo
      @urlinfo ||= (JSON.parse(urlinfo_json).first || {}) # return an empty hash if we received an empty json string from delicious
    end
    def bookmarks
      @bookmarks ||= (JSON.parse(bookmarks_json))
    end
  private
    def urlinfo_json
      @urlinfo_json ||= Net::HTTP.get(URI.parse("http://feeds.delicious.com/v2/json/urlinfo/#{@url_hash}"))
    end
    def bookmarks_json
      @bookmarks_json ||= Net::HTTP.get(URI.parse("http://feeds.delicious.com/v2/json/url/#{@url_hash}?count=100"))
    end
  end
end