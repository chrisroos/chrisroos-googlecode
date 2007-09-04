# CREDENTIALS
USERNAME = 'YOUR_USERNAME'
PASSWORD = 'YOUR_PASSWORD'
POSTS_CACHE = 'FILE_TO_STORE_YOUR_EXISTING_DELICIOUS_POSTS_IN'

# GET ALL POSTS
unless File.exists?(POSTS_CACHE)
  puts "Downloading all posts..."
  curl_cmd = <<-EndCurl
  curl "https://api.del.icio.us/v1/posts/all" \
  -u"#{USERNAME}:#{PASSWORD}" \
  -s \
  > #{POSTS_CACHE}
  EndCurl
  `#{curl_cmd}`
end

# # GET A SINGLE POST
# def get_post(url)
#   curl_cmd = <<-EndCurl
#   curl "https://api.del.icio.us/v1/posts/get" \
#   -u"#{USERNAME}:#{PASSWORD}" \
#   -d"url=#{url}"
#   EndCurl
#   `#{curl_cmd}`
# end

require 'hpricot'
require 'md5'
require 'cgi'

def add_url_hash_to_post(post)
  url = CGI.unescapeHTML(post['href'])
  url_hash = MD5.md5(url)
  url = CGI.escape(url)

  tags = post['tag'].split(' ').collect { |tag| CGI.unescapeHTML(tag) }
  tags << "url/#{url_hash}" unless tags.include?("url/#{url_hash}")
  tags = tags.collect { |tag| CGI.escape(tag) }
  tags = tags.join(' ')

  shared = post['shared']
  description = CGI.escape(CGI.unescapeHTML(post['description']))
  extended = CGI.escape(CGI.unescapeHTML(post['extended']))

  curl_cmd = <<-EndCurl
curl "https://api.del.icio.us/v1/posts/add" \
-u"#{USERNAME}:#{PASSWORD}" \
-d"url=#{url}" \
-d"description=#{description}" \
-d"extended=#{extended}" \
-d"tags=#{tags}" \
-d"shared=#{shared}" \
-s
  EndCurl
  puts curl_cmd
  `#{curl_cmd}`
end

# ADD THE URL/<md5_hash> TAG TO EACH POST
posts_xml = File.open(POSTS_CACHE) { |f| f.read }
posts_doc = Hpricot(posts_xml)
count = 1
(posts_doc/'posts'/'post').each do |post_xml|
  puts "Bookmark: #{count}" if (count % 5) == 0
  add_url_hash_to_post(post_xml.attributes)
  count += 1
end