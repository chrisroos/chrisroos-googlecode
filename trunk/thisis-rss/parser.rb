require 'hpricot'
require 'date'
require 'erb_renderer'
require 'article'
require 'json'

# download articles
# compare articles to those currently stored in the 'database'
# add to the database if not found
# reproduce feed from database

ARTICLES_FILESTORE = File.join(File.dirname(__FILE__), 'articles.yaml')
unless File.exists?(ARTICLES_FILESTORE)
  File.open(ARTICLES_FILESTORE, 'w')
end
NEWS_URL = 'http://thisis-rss.co.uk/sample-news.html'

require 'net/http'

uri = URI.parse(NEWS_URL)
response = Net::HTTP.start(uri.host, uri.port) do |http|
  http.get(uri.path)
end

# html_filename = File.join(File.dirname(__FILE__), 'sample-news.html')
# html = File.open(html_filename) { |f| f.read }
html = response.body
doc = Hpricot(html)

def tidy_text(text)
  text.gsub(/\r|\t|\n/, '')
end

articles = []

BASE_URL = 'http://www.thisiskent.co.uk'
(doc/'div.newsListingMainDivWidth').each do |element|
  url = [BASE_URL, (element/'a.lbblue').first.attributes['href']].join('/')
  
  uri = URI.parse(url)
  id = uri.query.split('&').collect { |key_and_value| key_and_value.split('=') }.select { |key, value| key == 'contentPK' }.flatten.last
  
  headline = (element/'a.lbblue').first.innerText
  headline = tidy_text(headline)
  
  content_container = (element/'p.ptag')
  (content_container/'a').remove # Remove the more link from the content paragraph
  
  date = (content_container/'i').remove.first.innerText # Extract the story date from the content paragraph
  day, month = date.split(' ')
  published = Time.parse("#{day}-#{month}-2008")
  
  content = content_container.first.innerText
  content = tidy_text(content)
  content = content.sub(/^: /, '') # Remove the colon that was there to separate the date from the content

  # articles << Article.new(id, published, headline, content, url)
  articles << {
    :id => id,
    :date => published,
    :headline => headline,
    :content => content,
    :url => url
  }
end

# all_articles_yaml = File.open(ARTICLES_FILESTORE) { |file| file.read }
# p all_articles_yaml
# all_articles = YAML.load(all_articles_yaml) #rescue []
# p articles
# File.open(ARTICLES_FILESTORE, 'w') { |file| file.puts(articles.to_yaml) }
# all_articles = YAML.load_file(ARTICLES_FILESTORE)
# p all_articles.length
# articles.each do |article|
  # p all_articles
  # unless all_articles.include?(article)
  #   p 'new article'
    # File.open(ARTICLES_FILESTORE, 'a') { |file| file.puts(article.to_yaml) }
  # end
# end

erb_template = File.join(File.dirname(__FILE__), "news.erb.atom")
renderer = ErbRenderer.new(erb_template, binding)
File.open(File.join(File.dirname(__FILE__), "news.atom"), 'w') { |io| renderer.render(io) }