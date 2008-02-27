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

MESSAGE_STORE = File.expand_path(File.join(File.dirname(__FILE__), '/messages'))
LAST_MESSAGE_PROCESSED = Dir["#{MESSAGE_STORE}/*"].collect { |f| File.basename(f).to_i }.sort.last

require 'yaml'

twitter_credentials = YAML.load_file(File.join(File.dirname(__FILE__), 'config', 'twitter.yaml'))
twitter = Twitter.new(twitter_credentials)
direct_messages = twitter.get_direct_messages(LAST_MESSAGE_PROCESSED)

puts "#{Time.now} - Processing #{direct_messages.size} messages."

require File.join(File.dirname(__FILE__), 'message_parser')
require File.join(File.dirname(__FILE__), 'searcher')
require File.join(File.dirname(__FILE__), 'parser')

direct_messages.each do |direct_message|
  msg_id = direct_message['id']
  msg_content = direct_message['text']
  reply_to = direct_message['sender']['screen_name']
  
  from, to = NatRailEnq::MessageParser.new(msg_content).parse
  searcher = NatRailEnq::Searcher.new(from, to)
  html = searcher.search_timetable
  parser = NatRailEnq::Parser.new(html)
  train_times = parser.parse_timetable
  
  response = twitter.reply_to(reply_to, train_times)
  
  File.open("#{MESSAGE_STORE}/#{msg_id}", 'a') { |f| f.puts [msg_content, reply_to, train_times, response.code, response.body].to_json }
end