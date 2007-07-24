USERNAME = 'natrailenq'
PASSWORD = ''

MESSAGE_STORE = File.expand_path(File.dirname(__FILE__) + '/messages')
MESSAGES_SINCE_ID = Dir["#{MESSAGE_STORE}/*"].collect { |f| File.basename(f).to_i }.sort.last
CURL_CMD = '/usr/local/bin/curl'

require 'rubygems'
require 'json'

require File.dirname(__FILE__) + '/nat-rail-enq'

url = "http://twitter.com/direct_messages.json"
url << "?since_id=#{MESSAGES_SINCE_ID}" if MESSAGES_SINCE_ID
curl_cmd = %[#{CURL_CMD} -u"#{USERNAME}:#{PASSWORD}" "#{url}" -s]

json = `#{curl_cmd}`

direct_messages = JSON.parse(json)
puts "#{Time.now} - Processing #{direct_messages.size} messages."
direct_messages.each do |direct_message|
  msg_id = direct_message['id']
  msg_content = direct_message['text']
  reply_to = direct_message['sender']['screen_name']
  
  params = NationalRailEnquiries::Parameters.new(msg_content)
  result = NationalRailEnquiries.search(params)
  
  curl_cmd = %[#{CURL_CMD} -u"#{USERNAME}:#{PASSWORD}" -X"POST" "http://twitter.com/direct_messages/new.json" -d"user=#{reply_to}" -d"text=#{result}" -s]
  response = `#{curl_cmd}`
  
  File.open("#{MESSAGE_STORE}/#{msg_id}", 'a') { |f| f.puts [msg_content, reply_to, result, response].to_json }
end
