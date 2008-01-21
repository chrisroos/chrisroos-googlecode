blog_urls_in_index = []

File.open('blog.seagul.co.uk_all_pages.tsv') do |file|
  file.each do |line|
    blog_urls_in_index << line[/(http:\/\/.*?)\t/, 1]
  end
end

rules = [
  {
    :description => "Paged tag resources should be redirected to the non-paged tag resource.",
    :pattern => /articles\/tag\/(.+?)\/page/,
    :expected_location => proc {"http://blog1.seagul.co.uk/articles/tag/#{$1}"},
    :expected_code => '301'
  },
  {
    :description => "Old tag resources (/tags instead of /tag) should be redirected to the correct tag resource.",
    :pattern => /articles\/tags\/(.+)/,
    :expected_location => proc {"http://blog1.seagul.co.uk/articles/tag/#{$1}"},
    :expected_code => '301'
  },
  {
    :description => "Paged year resources should be redirected to the non-paged year resource.",
    :pattern => /articles\/(\d{4})\/page.*/,
    :expected_location => proc {"http://blog1.seagul.co.uk/articles/#{$1}"},
    :expected_code => '301'
  },
  {
    :description => "Paged year/month resources should be redirected to the non-paged year/month resource.",
    :pattern => /articles\/(\d{4})\/(\d{2})\/page.*/,
    :expected_location => proc {"http://blog1.seagul.co.uk/articles/#{$1}/#{$2}"},
    :expected_code => '301'
  },
  {
    :description => "Paged year/month/day resources should be redirected to the non-paged year/month/day resource.",
    :pattern => /articles\/(\d{4})\/(\d{2})\/(\d{2})\/page.*/,
    :expected_location => proc {"http://blog1.seagul.co.uk/articles/#{$1}/#{$2}/#{$3}"},
    :expected_code => '301'
  },
  {
    :description => "Tag resources should render OK",
    :pattern => /articles\/tag\/.*/,
    :expected_code => '200'
  },
  {
    :description => "Page resources should render OK",
    :pattern => /\/pages\/.+/,
    :expected_code => '200'
  },
  {
    :description => "Year resources without a trailing slash should redirect to the same year resource with a trailing slash",
    :pattern => /articles\/(\d{4})$/,
    :expected_location => proc {"http://blog1.seagul.co.uk/articles/#{$1}/"},
    :expected_code => '301'
  },
  {
    :description => "Year resources should render OK",
    :pattern => /articles\/\d{4}\/$/,
    :expected_code => '200'
  },
  {
    :description => "Year/month resources without a trailing slash should redirect to the same resource with the trailing slash",
    :pattern => /articles\/(\d{4})\/(\d{2})$/,
    :expected_location => proc { "http://blog1.seagul.co.uk/articles/#{$1}/#{$2}/"},
    :expected_code => '301'
  },
  {
    :description => "Year/month resources with a one digit month should redirect to the same resource with a two digit month",
    :pattern => /articles\/(\d{4})\/(\d{1})$/,
    :expected_location => proc { "http://blog1.seagul.co.uk/articles/#{$1}/0#{$2}"},
    :expected_code => '301'
  },
  {
    :description => "Year/month resources should render OK",
    :pattern => /articles\/\d{4}\/\d{2}\/$/,
    :expected_code => '200'
  },
  {
    :description => "Year/month/day resources should render OK",
    :pattern => /articles\/\d{4}\/\d{2}\/\d{2}\/$/,
    :expected_code => '200'
  },
  {
    :description => "Article resources should render OK",
    :pattern => /articles\/\d{4}\/\d{2}\/\d{2}\/.+$/,
    :expected_code => '200'
  }
]

if false # SET TO TRUE TO TEST OUT THE RULES ON A SMALLER SET OF DATA
  blog_urls_in_index = []
  blog_urls_in_index << 'http://blog1.seagul.co.uk/articles/tag/ruby/page/2'
  blog_urls_in_index << 'http://blog1.seagul.co.uk/articles/tags/irb'
  blog_urls_in_index << 'http://blog1.seagul.co.uk/articles/2005/page/1'
  blog_urls_in_index << 'http://blog1.seagul.co.uk/articles/2005/01/page/1'
  blog_urls_in_index << 'http://blog1.seagul.co.uk/articles/2005/01/01/page/1'
  blog_urls_in_index << 'http://blog1.seagul.co.uk/articles/2005/10'
  blog_urls_in_index << 'http://blog1.seagul.co.uk/articles/2006/3'
  blog_urls_in_index << 'http://blog1.seagul.co.uk/pages/cyrus-imap'
end

require 'net/http'

blog_urls_in_index.compact.sort.each do |url|
  request_url = url.sub(/blog\.seagul/, 'blog1.seagul')
  
  url = URI.parse(request_url)
  request = Net::HTTP::Get.new(url.path)
  response = Net::HTTP.start(url.host, url.port) do |http|
    http.request(request)
  end
  
  matching_rule = rules.detect { |rule| request_url =~ rule[:pattern] }
  unless matching_rule
    puts "No rule found to match: #{request_url}"
  else
    expected_location = matching_rule[:expected_location] && matching_rule[:expected_location].call
    expected_code = matching_rule[:expected_code]
  
    msg = []
    unless expected_location == response['Location']
      msg << "Expected redirection to #{expected_location} but got redirected to #{response['Location']}"
    end
    unless expected_code == response.code
      msg << "Expected response code (#{expected_code}) but got response code (#{response.code})"
    end
    unless msg.empty?
      msg.unshift "Requested #{request_url}"
      puts msg.join(' ... ')
    end
  end
  
  # if response.code == '200'
  #   # All fine - don't report anything
  # elsif response.code == '301'
  #   if request_url =~ /articles\/tag\/(.+?)\/page/
  #     # A request for a paged tag resource.  Should be redirected to the resource with the paging part removed.
  #     expected_redirection = "http://blog1.seagul.co.uk/articles/tag/#{$1}"
  #     unless expected_redirection == response['Location']
  #       print "Requested: #{request_url}  ...  incorrectly redirected (301) to #{response['Location']}"
  #     end
  #   elsif request_url =~ /articles\/tags\/(.+)/
  #     # A request for an old tags resource.  Should be redirected to the corresponding tag resource.
  #     expected_redirection = "http://blog1.seagul.co.uk/articles/tag/#{$1}"
  #     unless expected_redirection == response['Location']
  #       print "Requested: #{request_url}  ...  incorrectly redirected (301) to #{response['Location']}"
  #     end
  #   elsif request_url =~ /articles\/(\d{4})\/page.*/
  #     # A request for a paged year resource.  Should be redirected to the resource with the paging part removed.
  #     expected_redirection = "http://blog1.seagul.co.uk/articles/#{$1}"
  #     unless expected_redirection == response['Location']
  #       print "Requested: #{request_url} ... incorrectly redirected (301) to #{response['Location']}"
  #     end
  #   elsif request_url =~ /articles\/(\d{4})\/(\d{2})\/page.*/
  #     # A request for a paged year/month resource.  Should be redirected to the resource with the paging part removed.
  #     expected_redirection = "http://blog1.seagul.co.uk/articles/#{$1}/#{$2}"
  #     unless expected_redirection == response['Location']
  #       print "Requested: #{request_url} ... incorrectly redirected (301) to #{response['Location']}"
  #     end
  #   elsif request_url =~ /articles\/(\d{4})\/(\d{2})\/(\d{2})\/page.*/
  #     # A request for a paged year/month/day resource.  Should be redirected to the resource with the paging part removed.
  #     expected_redirection = "http://blog1.seagul.co.uk/articles/#{$1}/#{$2}/#{$3}"
  #     unless expected_redirection == response['Location']
  #       print "Requested: #{request_url} ... incorrectly redirected (301) to #{response['Location']}"
  #     end
  #   else
  #     print "Requested: #{request_url}  ...  "
  #     puts "Redirected to #{response['Location']}"
  #   end
  # else
  #   print "Requested: #{request_url}  ...  "
  #   puts "(#{response.code})"
  # end
end