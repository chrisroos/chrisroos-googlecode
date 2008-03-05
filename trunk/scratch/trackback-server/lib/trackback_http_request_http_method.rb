class TrackbackHttpRequest
  class HttpMethod
  
    attr_reader :error
  
    def initialize(request_params)
      @request_params = request_params
      @error = nil
    end
  
    def valid?
      unless valid = @request_params['REQUEST_METHOD'] == 'POST'
        @error = 'Http Method MUST be POST'
      end
      valid
    end
  
  end
end