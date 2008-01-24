require 'comment'
require 'trackback'
require 'tag'
require 'syntax_highlighter'
require 'redcloth'

class Article < ActiveRecord::Base
  
  has_many :comments, :dependent => :destroy, :order => 'created_at ASC', :conditions => 'published = TRUE'
  has_many :trackbacks, :dependent => :destroy, :order => 'created_at ASC'
  has_and_belongs_to_many :tags, :foreign_key => 'article_id', :order => 'name'
  
  class << self
    def years_published
      articles = find(:all, :select => "YEAR(published_at) AS year", 
                            :group => 'year')
      articles.collect { |article| article.year }
    end
    def months_and_years_published
      articles = find(:all, :select => 'YEAR(published_at) AS year, MONTH(published_at) AS month', 
                            :group => 'year, month')
      articles.collect { |article| [article.month, article.year] }
    end
    def days_months_and_years_published
      articles = find(:all, :select => 'YEAR(published_at) AS year, MONTH(published_at) AS month, DAY(published_at) AS day', 
                            :group => 'year, month, day')
      articles.collect { |article| [article.day, article.month, article.year] }
    end
    def find_all_published_during(year, month = nil, day = nil)
      # Naughty Chris - leaving us open to sql injection attacks
      conditions = "YEAR(published_at) = '#{year}'"
      conditions += " AND MONTH(published_at) = '#{month}'" if month
      conditions += " AND DAY(published_at) = '#{day}'" if day
      find(:all, :conditions => conditions, :order => 'published_at DESC')
    end
  end
  
  def formatted_published_date
    published_at.strftime("%a, %d %b %Y %H:%M:%S")
  end
  
  def permalink
    title.downcase.tr("\"'", '').gsub(/\W/, ' ').strip.tr_s(' ', '-').tr(' ', '-').sub(/^$/, "-")
  end
  
  def body_html
    body = self.body.gsub(/<typo:code(.*?)>(.*?)<\/typo:code>/m) do
      code = $2
      lang = $1[/lang="(.*?)"/, 1]
      SyntaxHighlighter.markup_code(code, lang)
    end
    RedCloth.new(body).to_html(:textile)
  end
  
  def path
    year, month, day = published_at.to_date.to_s.split('-')
    File.join(ARTICLES_URL_ROOT, year, month, day)
  end
  
  def url
    # Representation agnostic (i.e. doesn't specify .html, .xml)
    File.join(path, permalink)
  end
  
  public :binding
  
end