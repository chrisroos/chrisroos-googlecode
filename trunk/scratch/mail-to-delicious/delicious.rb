require 'cgi'

class Delicious
  class Bookmark
    Url = 'https://api.del.icio.us/v1/posts/add'
    Username = 'chrisjroos'
    Password = '<top-secret>'
    UserAgent = "simply delicious ruby wrapper - chrisroos.co.uk"
    def initialize(url, title, notes, *tags)
      @url, @title, @notes, @tags = url, title, notes, tags
    end
    def save
      `curl "#{api_url}" --user "#{basic_auth_credentials}" --user-agent "#{UserAgent}"`
    end
    private
      attr_reader :url, :title, :notes
      def tags
        @tags.join(' ')
      end
      def querystring
        params.collect { |key, value| [key, sanitize(value)].join('=') }.join('&')
      end
      def params
        {
          :url => url,
          :description => title,
          :extended => notes,
          :tags => tags,
          :shared => 'no'
        }
      end
      def sanitize(value)
        CGI.escape(value)
      end
      def basic_auth_credentials
        [Username, Password].join(':')
      end
      def api_url
        [Url, querystring].join('?')
      end
  end
end

p Delicious::Bookmark.new('http://www.example.com', 'my & unsafe magical :: title', "some\nmulti\nline\nnotes").save