require 'erb_renderer'
require 'document_parser'
require 'articles'

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

class ArticlesView
  def initialize(articles, number_to_display)
    @articles, @number_to_display = articles, number_to_display
  end
  def each_article
    number_displayed = 0
    @articles.each do |article|
      break if number_displayed == @number_to_display
      yield article
      number_displayed += 1
    end
  end
  public :binding
end

articles_view = ArticlesView.new(articles, 1)

erb_template = File.join(File.dirname(__FILE__), "news.erb.atom")
renderer = ErbRenderer.new(erb_template, articles_view.binding)
File.open(File.join(File.dirname(__FILE__), "news.atom"), 'w') { |io| renderer.render(io) }