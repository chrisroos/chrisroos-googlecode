blog_urls_in_index = []

File.open('blog.seagul.co.uk_all_pages.tsv') do |file|
  file.each do |line|
    blog_urls_in_index << line[/(http:\/\/.*?)\t/, 1]
  end
end

# blog_urls_in_index = ['http://blog1.seagul.co.uk/articles/tag/ruby/page/2']
# blog_urls_in_index = ['http://blog1.seagul.co.uk/articles/tags/irb']

require 'net/http'

blog_urls_in_index.compact.sort.each do |url|
  request_url = url.sub(/blog\.seagul/, 'blog1.seagul')
  
  url = URI.parse(request_url)
  request = Net::HTTP::Get.new(url.path)
  response = Net::HTTP.start(url.host, url.port) do |http|
    http.request(request)
  end
  
  if response.code == '200'
    # All fine - don't report anything
  elsif response.code == '301'
    if request_url =~ /articles\/tag\/(.+?)\/page/
      # A request for a paged tag resource.  Should be redirected to the resource with the paging part removed.
      expected_redirection = "http://blog1.seagul.co.uk/articles/tag/#{$1}"
      unless expected_redirection == response['Location']
        print "Requested: #{request_url}  ...  incorrectly redirected (301) to #{response['Location']}"
      end
    elsif request_url =~ /articles\/tags\/(.+)/
      # A request for an old tags resource.  Should be redirected to the corresponding tag resource.
      expected_redirection = "http://blog1.seagul.co.uk/articles/tag/#{$1}"
      unless expected_redirection == response['Location']
        print "Requested: #{request_url}  ...  incorrectly redirected (301) to #{response['Location']}"
      end
    else
      print "Requested: #{request_url}  ...  "
      puts "Redirected to #{response['Location']}"
    end
  else
    print "Requested: #{request_url}  ...  "
    puts "(#{response.code})"
  end
end