require 'cgi'

# TODO: implement tag (and, possibly shared, support)

class Delicious
  class Bookmark
    Url = 'https://api.del.icio.us/v1/posts/add'
    Username = 'chrisjroos'
    Password = '<top-secret>'
    def initialize(url, title, notes)
      @params = {
        :url => url,
        :description => title,
        :extended => notes,
        :shared => 'no'
      }
    end
    def save
      url = [Url, querystring].join('?')
      `curl "#{url}" --user "#{basic_auth_credentials}"`
    end
    private
      def querystring
        @params.collect { |key, value| [key, sanitize(value)].join('=') }.join('&')
      end
      def sanitize(value)
        CGI.escape(value)
      end
      def basic_auth_credentials
        [Username, Password].join(':')
      end
  end
end

p Delicious::Bookmark.new('http://www.example.com', 'my & unsafe magical :: title', "some\nmulti\nline\nnotes", 'tag1').save