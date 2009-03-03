require 'rubygems'
require 'tmail'
require 'cgi'

module Delicious
  
  class BookmarkParser
    attr_reader :title, :url, :notes, :tags
    def initialize(email)
      tmail = TMail::Mail.parse(email)
      @title = tmail.subject
      @body = tmail.parts[0].body rescue '' # We assume that part 0 is text/plain, this could be somewhat more robust
      @notes, @url, @tags = '', '', []
    end
    def parse!
      @body.each_with_index do |line, index|
        if index == 0
          @url = line.chomp
        elsif line =~ /^T /
          @tags = line.sub(/^T /, '').split(' ')
        else
          @notes << line.chomp
        end
      end
    end
  end
  
  class Bookmark
    Url = 'https://api.del.icio.us/v1/posts/add'
    Username = 'chrisjroos'
    Password = '<top-secret>'
    UserAgent = "simply delicious ruby wrapper - chrisroos.co.uk"
    def self.from_email(email)
      parser = BookmarkParser.new(email)
      parser.parse!
      new(parser.url, parser.title, parser.notes, *parser.tags)
    end
    def initialize(url, title, notes, *tags)
      @url, @title, @notes, @tags = url, title, notes, tags
    end
    def save
      cmd = %%curl "#{api_url}" --user "#{basic_auth_credentials}" --user-agent "#{UserAgent}"%
      `#{cmd}`
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

# p Delicious::Bookmark.new('http://www.example.com', 'my & unsafe magical :: title', "some\nmulti\nline\nnotes").save
# email = File.read('delicious_test.rb')[/__END__\n(.*)/m, 1]
# p Delicious::Bookmark.from_email(email).save