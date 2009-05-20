require 'uri'

class HttpBody
  
  def initialize(body)
    @data = body.split('&').inject({}) do |hash, key_and_value|
      key, value = key_and_value.split('=')
      value = '' if value.nil? # URI.unescape will fail if value is nil (if we've left out the excert, for example)
      hash[key] = URI.unescape(value)
      hash
    end
  end
  
  def to_hash
    @data
  end
  
end