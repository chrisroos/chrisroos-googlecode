blog_urls_in_index = []

File.open('blog.seagul.co.uk_all_pages.tsv') do |file|
  file.each do |line|
    blog_urls_in_index << line[/(http:\/\/.*?)\t/, 1]
  end
end

rules = [
  {
    :description => "The root resource (latest articles) should render OK.",
    :pattern => /^\/$/,
    :expected_code => '200'
  },
  {
    :description => "The root index resource should redirect to the root resource.",
    :pattern => /^\/index.html$/,
    :expected_location => proc { "http://blog1.seagul.co.uk/" },
    :expected_code => '301'
  },
  {
    :description => "The contents.html resource should redirect to the contents resource.",
    :pattern => /^\/contents.html$/,
    :expected_location => proc { "http://blog1.seagul.co.uk/contents" },
    :expected_code => '301'
  },
  {
    :description => "The contents resource should render correctly.",
    :pattern => /^\/contents$/,
    :expected_code => '200'
  },
  {
    :description => "The articles resource should be redirected to the root resource (they are, afterall, the same thing).",
    :pattern => /^\/articles\/$/,
    :expected_location => proc { "http://blog1.seagul.co.uk/" },
    :expected_code => '301'
  },
  {
    :description => "Paged tag resources should be redirected to the non-paged tag resource.",
    :pattern => /^\/articles\/tag\/(.+?)\/page/,
    :expected_location => proc { "http://blog1.seagul.co.uk/articles/tag/#{$1}" },
    :expected_code => '301'
  },
  {
    :description => "Old tag resources (/tags instead of /tag) should be redirected to the correct tag resource.",
    :pattern => /^\/articles\/tags\/(.+)/,
    :expected_location => proc { "http://blog1.seagul.co.uk/articles/tag/#{$1}" },
    :expected_code => '301'
  },
  {
    :description => "The year/index resource should be redirected to the year/ resource.",
    :pattern => /^\/articles\/(\d{4})\/index\.html$/,
    :expected_location => proc { "http://blog1.seagul.co.uk/articles/#{$1}/" },
    :expected_code => '301'
  },
  {
    :description => "Paged year resources should be redirected to the non-paged year/ resource.",
    :pattern => /^\/articles\/(\d{4})\/page.*/,
    :expected_location => proc { "http://blog1.seagul.co.uk/articles/#{$1}/" },
    :expected_code => '301'
  },
  {
    :description => "The year/month/index resource should be redirected to the year/month/ resource.",
    :pattern => /^\/articles\/(\d{4})\/(\d{2})\/index\.html$/,
    :expected_location => proc { "http://blog1.seagul.co.uk/articles/#{$1}/#{$2}/" },
    :expected_code => '301'
  },
  {
    :description => "Paged year/month resources should be redirected to the non-paged year/month/ resource.",
    :pattern => /^\/articles\/(\d{4})\/(\d{2})\/page.*/,
    :expected_location => proc { "http://blog1.seagul.co.uk/articles/#{$1}/#{$2}/" },
    :expected_code => '301'
  },
  {
    :description => "Year/month/day/index.html resource should be redirected to the root year/month/day/ resource.",
    :pattern => /^\/articles\/(\d{4})\/(\d{2})\/(\d{2})\/index\.html/,
    :expected_location => proc { "http://blog1.seagul.co.uk/articles/#{$1}/#{$2}/#{$3}/" },
    :expected_code => '301'
  },
  {
    :description => "Paged year/month/day resources should be redirected to the non-paged year/month/day/ resource.",
    :pattern => /^\/articles\/(\d{4})\/(\d{2})\/(\d{2})\/page.*/,
    :expected_location => proc { "http://blog1.seagul.co.uk/articles/#{$1}/#{$2}/#{$3}/" },
    :expected_code => '301'
  },
  {
    :description => "Tag resources should render OK",
    :pattern => /^\/articles\/tag\/.*/,
    :expected_code => '200'
  },
  {
    :description => "Page resources should render OK",
    :pattern => /^\/pages\/.+/,
    :expected_code => '200'
  },
  {
    :description => "Year resources without a trailing slash should redirect to the same year resource with a trailing slash",
    :pattern => /^\/articles\/(\d{4})$/,
    :expected_location => proc { "http://blog1.seagul.co.uk/articles/#{$1}/" },
    :expected_code => '301'
  },
  {
    :description => "Year resources should render OK",
    :pattern => /^\/articles\/\d{4}\/$/,
    :expected_code => '200'
  },
  {
    :description => "Year/month resources without a trailing slash should redirect to the same resource with the trailing slash",
    :pattern => /^\/articles\/(\d{4})\/(\d{2})$/,
    :expected_location => proc { "http://blog1.seagul.co.uk/articles/#{$1}/#{$2}/" },
    :expected_code => '301'
  },
  {
    :description => "Year/month resources with a one digit month should redirect to the same resource with a two digit month",
    :pattern => /^\/articles\/(\d{4})\/(\d{1})$/,
    :expected_location => proc { "http://blog1.seagul.co.uk/articles/#{$1}/0#{$2}/" },
    :expected_code => '301'
  },
  {
    :description => "Paged year/one-digit-month resources should be redirected to the non-paged year/two-digit-month resource.",
    :pattern => /^\/articles\/(\d{4})\/(\d{1})\/page.*/,
    :expected_location => proc {"http://blog1.seagul.co.uk/articles/#{$1}/0#{$2}/"},
    :expected_code => '301'
  },
  {
    :description => "Year/month resources should render OK",
    :pattern => /^\/articles\/\d{4}\/\d{2}\/$/,
    :expected_code => '200'
  },
  {
    :description => "Year/month/day resources should render OK",
    :pattern => /^\/articles\/\d{4}\/\d{2}\/\d{2}\/$/,
    :expected_code => '200'
  },
  {
    :description => "Article resources should render OK",
    :pattern => /^\/articles\/\d{4}\/\d{2}\/\d{2}\/.+$/,
    :expected_code => '200'
  },
  {
    :description => "Textile markup help should be permanently redirected to _why's reference",
    :pattern => /^\/articles\/markup_help\/5$/,
    :expected_location => proc { "http://hobix.com/textile/" },
    :expected_code => '301'
  }
]

if true # SET TO TRUE TO TEST OUT THE RULES ON A SMALLER SET OF DATA
  blog_urls_in_index = []
  blog_urls_in_index << 'http://blog1.seagul.co.uk/'
  blog_urls_in_index << 'http://blog1.seagul.co.uk/index.html'
  blog_urls_in_index << 'http://blog1.seagul.co.uk/contents.html'
  blog_urls_in_index << 'http://blog1.seagul.co.uk/contents'
  blog_urls_in_index << 'http://blog1.seagul.co.uk/articles/'
  blog_urls_in_index << 'http://blog1.seagul.co.uk/articles/tag/ruby/page/2'
  blog_urls_in_index << 'http://blog1.seagul.co.uk/articles/tags/irb'
  blog_urls_in_index << 'http://blog1.seagul.co.uk/articles/2005/page/1'
  blog_urls_in_index << 'http://blog1.seagul.co.uk/articles/2005/index.html'
  blog_urls_in_index << 'http://blog1.seagul.co.uk/articles/2005/01/page/1'
  blog_urls_in_index << 'http://blog1.seagul.co.uk/articles/2005/09/index.html'
  blog_urls_in_index << 'http://blog1.seagul.co.uk/articles/2005/01/01/page/1'
  blog_urls_in_index << 'http://blog1.seagul.co.uk/articles/2005/09/06/index.html'
  blog_urls_in_index << 'http://blog1.seagul.co.uk/articles/2005/10'
  blog_urls_in_index << 'http://blog1.seagul.co.uk/articles/2006/3'
  blog_urls_in_index << 'http://blog1.seagul.co.uk/articles/2006/3/page/1'
  blog_urls_in_index << 'http://blog1.seagul.co.uk/pages/cyrus-imap'
  blog_urls_in_index << 'http://blog1.seagul.co.uk/articles/markup_help/5'
end

require 'net/http'

blog_urls_in_index.compact.sort.each do |url|
  request_url = url.sub(/blog\.seagul/, 'blog1.seagul')
  
  url = URI.parse(request_url)
  request = Net::HTTP::Get.new(url.path)
  response = Net::HTTP.start(url.host, url.port) do |http|
    http.request(request)
  end

  matching_rule = rules.detect { |rule| url.path =~ rule[:pattern] }
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
end