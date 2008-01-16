class Date
  def iso8601
    Time.parse(self.to_s).iso8601
  end
end

class Paper
  public :binding
  attr_reader :title, :date, :articles
  def initialize(title, date)
    @title, @date = title, date
    @articles, @articles_by_page_number = [], {}
  end
  def add_article(article)
    @articles << article
    @articles_by_page_number[article.page_number] ||= []
    @articles_by_page_number[article.page_number] << article
  end
  def each_page_with_articles
    @articles_by_page_number.sort { |(p1, a1), (p2, a2)| p1 <=> p2 }.each { |page_number, articles| yield page_number, articles }
  end
  def html_title
    "#{self.title} on #{self.human_friendly_date}"
  end
  def human_friendly_date
    self.date.strftime("%A %d %b %Y")
  end
  def iso8601_date
    self.date.iso8601
  end
  def url_friendly_title
    title.downcase.gsub(/ /, '-')
  end
end

class Article
  public :binding
  attr_reader :paper, :title, :author, :page_number, :other_attributes
  def initialize(paper, title, author, page_number, other_attributes)
    @paper, @title, @author, @page_number, @other_attributes = paper, title, author, Integer(page_number), other_attributes
    @paper.add_article(self)
  end
  def html_title
    "#{self.title} - #{paper.html_title}"
  end
  def iso8601_published_date
    paper.iso8601_date
  end
  def human_friendly_published_date
    paper.human_friendly_date
  end
  def paper_name
    paper.title
  end
  def url_friendly_title
    title.downcase.gsub(/ /, '-').gsub(/[^a-zA-Z0-9-]/, '').squeeze('-')
  end  
end

# Let's use the parser to extract some real data and construct our object graph
require File.join(File.dirname(__FILE__), 'parser')

SITE_FOLDER = File.join(File.dirname(__FILE__), 'Site')
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