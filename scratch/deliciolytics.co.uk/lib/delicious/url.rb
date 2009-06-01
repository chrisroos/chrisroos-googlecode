require 'json'

module Delicious
  class Url
    def initialize(url_hash)
      @url_hash = url_hash
    end
    def urlinfo
      @urlinfo ||= (JSON.parse(urlinfo_json).first || {}) # return an empty hash if we received an empty json string from delicious
    end
  private
    def urlinfo_json
      @urlinfo_json ||= Net::HTTP.get(URI.parse("http://feeds.delicious.com/v2/json/urlinfo/#{@url_hash}"))
    end
  end
end