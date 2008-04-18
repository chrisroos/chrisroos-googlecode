require File.join(File.dirname(__FILE__), 'http_body')

class TrackbackHttpRequest
  class Trackback
    
    def self.from_http_request(http_request)
      body = http_request.body.read
      http_body = HttpBody.new(body)
      new(http_body.to_hash)
    end
    
    attr_reader :error
    
    def initialize(attributes)
      @attributes = attributes.merge('received_at' => Time.now)
      @error = nil
    end
    
    def valid?
      unless valid = @attributes['url']
        @error = "You MUST send the URL of your post (permalink) that mentions this post."
      end
      valid
    end

    def to_hash
      @attributes
    end
    
  end
end