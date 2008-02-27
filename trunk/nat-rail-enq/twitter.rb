require 'yaml'

twitter_credentials = YAML.load_file(File.join(File.dirname(__FILE__), 'config', 'twitter.yaml'))

MESSAGE_STORE = File.expand_path(File.join(File.dirname(__FILE__), '/messages'))
LAST_MESSAGE_PROCESSED = Dir["#{MESSAGE_STORE}/*"].collect { |f| File.basename(f).to_i }.sort.last

require 'rubygems'
require 'net/http'
require 'json'

host = 'http://twitter.com'
path = 'direct_messages.json'
query_string = "since_id=#{LAST_MESSAGE_PROCESSED}" if LAST_MESSAGE_PROCESSED

uri = URI.parse [host, '/', path, '?', query_string].join('')

response = Net::HTTP.start(uri.host, uri.port) do |http|
  request = Net::HTTP::Get.new(uri.request_uri)
  request.basic_auth twitter_credentials[:username], twitter_credentials[:password]
  http.request(request)
end

direct_messages = JSON.parse(response.body)
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
  
  uri = URI.parse('http://twitter.com/direct_messages/new.json')
  response = Net::HTTP.start(uri.host, uri.port) do |http|
    request = Net::HTTP::Post.new(uri.request_uri)
    request.basic_auth twitter_credentials[:username], twitter_credentials[:password]
    request.set_form_data('user' => reply_to, 'text' => train_times)
    http.request(request)
  end
  
  File.open("#{MESSAGE_STORE}/#{msg_id}", 'a') { |f| f.puts [msg_content, reply_to, train_times, response.code, response.body].to_json }
end