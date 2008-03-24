# Let's use the parser to extract some real data and construct our object graph
require File.join(File.dirname(__FILE__), 'parser')
require File.join(File.dirname(__FILE__), 'article')
require File.join(File.dirname(__FILE__), 'paper')
require File.join(File.dirname(__FILE__), 'date')

SITE_FOLDER = File.join(File.dirname(__FILE__), 'public')
RAW_DATA_FOLDER = File.join(SITE_FOLDER, 'raw-data')

Dir[File.join(RAW_DATA_FOLDER, '*.txt')].each do |filename|

  paper_attributes = PaperParser.parse(filename)
  paper = Paper.new(paper_attributes[:title], paper_attributes[:date])
  File.open(filename) do |file|
    article_parser = ArticleParser.new(file)
    article_parser.each do |article_attributes|
      article = Article.new(paper, article_attributes[:title], article_attributes[:author], article_attributes[:page_number], article_attributes[:attributes])
    end
  end

  # Let's use the object graph to create some html pages
  require 'erb'
  include ERB::Util

  article_template = File.open('article.erb.html') { |f| f.read }
  article_erb = ERB.new(article_template)
  paper_template = File.open('paper.erb.html') { |f| f.read }
  paper_erb = ERB.new(paper_template)

  def render_to_file(filename, string)
    File.open(filename, 'w') do |f|
      f.puts(string)
    end
  end

  require 'fileutils'

  paper_year, paper_month, paper_day = paper.date.to_s.split('-')
  paper_directory = File.join(SITE_FOLDER, paper.url_friendly_title, paper_year.to_s, paper_month.to_s, paper_day.to_s)
  FileUtils.mkdir_p(paper_directory)

  paper_filename = File.join(paper_directory, "index.html")
  paper_content = paper_erb.result(paper.binding)
  render_to_file(paper_filename, paper_content)

  paper.articles.each do |article|
    article_filename = File.join(paper_directory, "#{article.url_friendly_title}.html")
    article_content = article_erb.result(article.binding)
    render_to_file(article_filename, article_content)
  end
  
end