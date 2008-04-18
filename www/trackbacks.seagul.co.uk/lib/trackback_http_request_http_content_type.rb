class TrackbackHttpRequest
  class HttpContentType
  
    attr_reader :error
  
    def initialize(request_params)
      @request_params = request_params
      @error = nil
    end
  
    def valid?
      unless valid = @request_params['HTTP_CONTENT_TYPE'] =~ /^application\/x-www-form-urlencoded/
        @error = "Content-Type MUST be 'application/x-www-form-urlencoded' with OPTIONAL character encoding"
      end
      valid
    end
  
  end
end