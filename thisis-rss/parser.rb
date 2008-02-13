$: << File.join(File.dirname(__FILE__), 'lib')
require 'erb_renderer'
require 'document_parser'
require 'articles'
require 'articles_view'

# download articles
# compare articles to those currently stored in the 'database'
# add to the database if not found
# reproduce feed from database

ArticlesFilename = File.join(File.dirname(__FILE__), 'articles.yaml')
File.open(ArticlesFilename, 'w') unless File.exists?(ArticlesFilename) # Create if it doesn't already exist

articles = Articles.retrieve_from_yaml_file(ArticlesFilename)

html_filename = File.join(File.dirname(__FILE__), 'sample-news.html')

parser = DocumentParser.from_file(html_filename)
parser.each_article_attributes do |article_attributes|
  articles.add(article_attributes)
end

articles.store_to_yaml_file(ArticlesFilename)

articles_view = ArticlesView.new(articles, 2)

erb_template = File.join(File.dirname(__FILE__), "news.erb.atom")
renderer = ErbRenderer.new(erb_template, articles_view.binding)
File.open(File.join(File.dirname(__FILE__), "news.atom"), 'w') { |io| renderer.render(io) }