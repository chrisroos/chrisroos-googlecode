$: << File.join(File.dirname(__FILE__), '..', 'app', 'lib')

require 'erb_renderer'
require 'document_parser'
require 'articles'
require 'articles_view'
require File.join(File.dirname(__FILE__), '..', 'lib', 'time')

DATA_DIRECTORY = File.join(File.dirname(__FILE__), '..', 'data')
HTML_DIRECTORY = File.join(DATA_DIRECTORY, 'html_files')
TEMPLATE_DIRECTORY = File.join(File.dirname(__FILE__), '..', 'app', 'templates')
PUBLIC_DIRECTORY = File.join(File.dirname(__FILE__), '..', 'public')

ArticlesFilename = File.join(DATA_DIRECTORY, 'articles.yaml')
File.open(ArticlesFilename, 'w') unless File.exists?(ArticlesFilename) # Create if it doesn't already exist

articles = Articles.retrieve_from_yaml_file(ArticlesFilename)

def spider(url, articles, continue_to_next_page = true)
  unless url
    p "URL is empty, I guess we're all finished"
    return
  end
  
  p "Spidering: #{url}"
  parser = DocumentParser.from_url(url)
  duplicate_article_found = false
  parser.each_article_attributes do |article_attributes|
    article_added = articles.add(article_attributes)
    duplicate_article_found = true unless article_added
  end
  
  spider(parser.next_page_url, articles, continue_to_next_page) if continue_to_next_page && !duplicate_article_found
end

# *** Let's get some article data so that we don't have to go spider every news page
# spider('http://www.thisiskent.co.uk/displayNode.jsp?nodeId=250439&command=refreshModule&sourceNode=250439&page=8&pNodeId=250478', articles, false)
# Spider 'new' pages
spider('http://www.thisiskent.co.uk/displayNode.jsp?nodeId=250478&command=newPage', articles)

articles.store_to_yaml_file(ArticlesFilename)

articles_view = ArticlesView.new(articles, 50)

erb_template = File.join(TEMPLATE_DIRECTORY, "news.erb.atom")
renderer = ErbRenderer.new(erb_template, articles_view.binding)
File.open(File.join(PUBLIC_DIRECTORY, "news.atom"), 'w') { |io| renderer.render(io) }