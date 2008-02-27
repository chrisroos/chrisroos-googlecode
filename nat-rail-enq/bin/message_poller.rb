require 'yaml'
require File.join(File.dirname(__FILE__), '..', 'config', 'environment')

last_message_processed = Dir["#{MESSAGE_STORE}/*"].collect { |f| File.basename(f).to_i }.sort.last

twitter_credentials = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'config', 'twitter.yaml'))
twitter = Twitter.new(twitter_credentials)
direct_messages = twitter.get_direct_messages(last_message_processed)

puts "#{Time.now} - Processing #{direct_messages.size} messages."

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