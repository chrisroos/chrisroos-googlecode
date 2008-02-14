$: << File.join(File.dirname(__FILE__), '..', 'app', 'lib')

require 'erb_renderer'
require 'document_parser'
require 'articles'
require 'articles_view'

DATA_DIRECTORY = File.join(File.dirname(__FILE__), '..', 'data')
HTML_DIRECTORY = File.join(DATA_DIRECTORY, 'html_files')
TEMPLATE_DIRECTORY = File.join(File.dirname(__FILE__), '..', 'app', 'templates')
PUBLIC_DIRECTORY = File.join(File.dirname(__FILE__), '..', 'public')

ArticlesFilename = File.join(DATA_DIRECTORY, 'articles.yaml')
File.open(ArticlesFilename, 'w') unless File.exists?(ArticlesFilename) # Create if it doesn't already exist

articles = Articles.retrieve_from_yaml_file(ArticlesFilename)

# Dir[File.join(HTML_DIRECTORY, '*.html')].each do |html_filename|
  # html_filename = File.join(HTML_DIRECTORY, 'sample-news.html')

  # parser = DocumentParser.from_file(html_filename)
  parser = DocumentParser.from_url('http://www.thisiskent.co.uk/displayNode.jsp?nodeId=250478&command=newPage')
  duplicate_article_found = false
  parser.each_article_attributes do |article_attributes|
    article_added = articles.add(article_attributes)
    duplicate_article_found = true unless article_added
  end
  unless duplicate_article_found
    p parser.next_page_url
  end

# end

articles.store_to_yaml_file(ArticlesFilename)

articles_view = ArticlesView.new(articles, 15)

erb_template = File.join(TEMPLATE_DIRECTORY, "news.erb.atom")
renderer = ErbRenderer.new(erb_template, articles_view.binding)
File.open(File.join(PUBLIC_DIRECTORY, "news.atom"), 'w') { |io| renderer.render(io) }