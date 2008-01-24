#! /usr/bin/env ruby

rules = [
  {
    :description => "Mis-spelled URL should redirect to correct spelling (this is so that I can remove the permalink column from articles and dymanically generate)",
    :pattern => /^\/articles\/2006\/12\/10\/crapy-ruby-script-to-download-photos-from-a-flickr-photoset$/,
    :expected_location => proc { "http://blog.seagul.co.uk/articles/2006/12/10/crappy-ruby-script-to-download-photos-from-a-flickr-photoset" },
    :expected_code => '301'
  },
  {
    :description => "The root resource (latest articles) should render OK.",
    :pattern => /^\/$/,
    :expected_code => '200'
  },
  {
    :description => "The root index resource should redirect to the root resource.",
    :pattern => /^\/index.html$/,
    :expected_location => proc { "http://blog.seagul.co.uk/" },
    :expected_code => '301'
  },
  {
    :description => "The contents.html resource should redirect to the contents resource.",
    :pattern => /^\/contents.html$/,
    :expected_location => proc { "http://blog.seagul.co.uk/contents" },
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
    :expected_location => proc { "http://blog.seagul.co.uk/" },
    :expected_code => '301'
  },
  {
    :description => "Paged article resources should be redirected to the table of contents.",
    :pattern => /^\/articles\/page.+$/,
    :expected_location => proc { "http://blog.seagul.co.uk/contents" },
    :expected_code => '301'
  },
  {
    :description => "Paged tag resources should be redirected to the non-paged tag resource.",
    :pattern => /^\/articles\/tag\/(.+?)\/page/,
    :expected_location => proc { "http://blog.seagul.co.uk/articles/tag/#{$1}" },
    :expected_code => '301'
  },
  {
    :description => "Old tag resources (/tags instead of /tag) should be redirected to the correct tag resource.",
    :pattern => /^\/articles\/tags\/(.+)/,
    :expected_location => proc { "http://blog.seagul.co.uk/articles/tag/#{$1}" },
    :expected_code => '301'
  },
  {
    :description => "The 'index' tag (index.html) should redirect to 'index', i.e. remove .html",
    :pattern => /^\/articles\/tag\/index\.html/,
    :expected_location => proc { "http://blog.seagul.co.uk/articles/tag/index" },
    :expected_code => '301'
  },
  {
    :description => "Tag resources ending in .html should redirect to the corresponding tag",
    :pattern => /^\/articles\/tag\/(.+?)\.html/,
    :expected_location => proc { "http://blog.seagul.co.uk/articles/tag/#{$1}" },
    :expected_code => '301'
  },
  {
    :description => "The year/index resource should be redirected to the year/ resource.",
    :pattern => /^\/articles\/(\d{4})\/index\.html$/,
    :expected_location => proc { "http://blog.seagul.co.uk/articles/#{$1}/" },
    :expected_code => '301'
  },
  {
    :description => "Paged year resources should be redirected to the non-paged year/ resource.",
    :pattern => /^\/articles\/(\d{4})\/page.*/,
    :expected_location => proc { "http://blog.seagul.co.uk/articles/#{$1}/" },
    :expected_code => '301'
  },
  {
    :description => "The year/month/index resource should be redirected to the year/month/ resource.",
    :pattern => /^\/articles\/(\d{4})\/(\d{2})\/index\.html$/,
    :expected_location => proc { "http://blog.seagul.co.uk/articles/#{$1}/#{$2}/" },
    :expected_code => '301'
  },
  {
    :description => "Paged year/month resources should be redirected to the non-paged year/month/ resource.",
    :pattern => /^\/articles\/(\d{4})\/(\d{2})\/page.*/,
    :expected_location => proc { "http://blog.seagul.co.uk/articles/#{$1}/#{$2}/" },
    :expected_code => '301'
  },
  {
    :description => "Year/month/day/index.html resource should be redirected to the root year/month/day/ resource.",
    :pattern => /^\/articles\/(\d{4})\/(\d{2})\/(\d{2})\/index\.html/,
    :expected_location => proc { "http://blog.seagul.co.uk/articles/#{$1}/#{$2}/#{$3}/" },
    :expected_code => '301'
  },
  {
    :description => "Paged year/month/day resources should be redirected to the non-paged year/month/day/ resource.",
    :pattern => /^\/articles\/(\d{4})\/(\d{2})\/(\d{2})\/page.*/,
    :expected_location => proc { "http://blog.seagul.co.uk/articles/#{$1}/#{$2}/#{$3}/" },
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
    :expected_location => proc { "http://blog.seagul.co.uk/articles/#{$1}/" },
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
    :expected_location => proc { "http://blog.seagul.co.uk/articles/#{$1}/#{$2}/" },
    :expected_code => '301'
  },
  {
    :description => "Year/month resources with a one digit month should redirect to the same resource with a two digit month",
    :pattern => /^\/articles\/(\d{4})\/(\d{1})$/,
    :expected_location => proc { "http://blog.seagul.co.uk/articles/#{$1}/0#{$2}/" },
    :expected_code => '301'
  },
  {
    :description => "Paged year/one-digit-month resources should be redirected to the non-paged year/two-digit-month resource.",
    :pattern => /^\/articles\/(\d{4})\/(\d{1})\/page.*/,
    :expected_location => proc {"http://blog.seagul.co.uk/articles/#{$1}/0#{$2}/"},
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
  },
  {
    :description => "RSS feed with .xml extension should redirect to file without extension",
    :pattern => /^\/xml\/rss\.xml$/,
    :expected_location => proc { "http://blog.seagul.co.uk/xml/rss" },
    :expected_code => '301'
  },
  {
    :description => "RSS feed of latest articles should render OK",
    :pattern => /^\/xml\/rss$/,
    :expected_code => '200'
  },
  {
    :description => "Legacy RSS 2.0 feed should redirect to feedburner (copied from http config for old blog)",
    :pattern => /^\/xml\/rss20\/feed\.xml$/,
    :expected_location => proc { "http://feeds.feedburner.com/DeferredUntilInspirationHits" },
    :expected_code => '301'
  },
  {
    :description => "Legacy Atom 1.0 feed should redirect to feedburner (copied from http config for old blog)",
    :pattern => /^\/xml\/atom10\/feed\.xml$/,
    :expected_location => proc { "http://feeds.feedburner.com/DeferredUntilInspirationHits" },
    :expected_code => '301'
  },
  {
    :description => "Legacy RSS (1?) feed should redirect to feedburner (copied from http config for old blog)",
    :pattern => /^\/xml\/rss\/feed\.xml$/,
    :expected_location => proc { "http://feeds.feedburner.com/DeferredUntilInspirationHits" },
    :expected_code => '301'
  }
]

require 'net/http'

while request_url = gets
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