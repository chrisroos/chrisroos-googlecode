require 'erb_renderer'
require 'document_parser'

# download articles
# compare articles to those currently stored in the 'database'
# add to the database if not found
# reproduce feed from database

articles = []

html_filename = File.join(File.dirname(__FILE__), 'sample-news.html')

parser = DocumentParser.from_file(html_filename)
parser.each_article_attributes do |article_attributes|
  articles << article_attributes
end

# STORE THE ARTICLES IN A 'DATABASE' CHECKING FOR DUPLICATES ALONG THE WAY

# RENDER THE NEWS ATOM FEED FROM THE ARTICLES IN THE 'DATABASE'

erb_template = File.join(File.dirname(__FILE__), "news.erb.atom")
renderer = ErbRenderer.new(erb_template, binding)
File.open(File.join(File.dirname(__FILE__), "news.atom"), 'w') { |io| renderer.render(io) }