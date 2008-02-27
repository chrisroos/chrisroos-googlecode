require 'net/http'
require 'json'

class Twitter
  Host = 'http://twitter.com'
  def initialize(credentials)
    @credentials = credentials
  end
  def get_direct_messages(since_message_id = nil)
    path = 'direct_messages.json'
    query_string = "since_id=#{since_message_id}" if since_message_id

    uri = URI.parse [Host, '/', path, '?', query_string].join('')

    response = Net::HTTP.start(uri.host, uri.port) do |http|
      request = Net::HTTP::Get.new(uri.request_uri)
      request.basic_auth @credentials[:username], @credentials[:password]
      http.request(request)
    end
    direct_messages = JSON.parse(response.body)
  end
  def reply_to(to, data)
    uri = URI.parse [Host, 'direct_messages/new.json'].join('/')
    Net::HTTP.start(uri.host, uri.port) do |http|
      request = Net::HTTP::Post.new(uri.request_uri)
      request.basic_auth @credentials[:username], @credentials[:password]
      request.set_form_data('user' => to, 'text' => data)
      http.request(request)
    end
  end
end