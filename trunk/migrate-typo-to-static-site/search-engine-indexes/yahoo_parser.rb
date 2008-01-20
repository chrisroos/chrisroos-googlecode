blog_urls_in_index = []

File.open('blog.seagul.co.uk_all_pages.tsv') do |file|
  file.each do |line|
    blog_urls_in_index << line[/(http:\/\/.*?)\t/, 1]
  end
end

require 'net/http'

blog_urls_in_index.compact.sort.each do |url|
  request_url = url.sub(/blog\.seagul/, 'blog1.seagul')
  
  url = URI.parse(request_url)
  request = Net::HTTP::Get.new(url.path)
  response = Net::HTTP.start(url.host, url.port) do |http|
    http.request(request)
  end
  
  unless response.code == '200'
    print "Requested: #{request_url}  ...  "
    puts "(#{response.code})"
  end
end