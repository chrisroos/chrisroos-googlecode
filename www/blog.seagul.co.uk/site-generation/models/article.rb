require 'comment'
require 'trackback'
require 'tag'
require 'syntax_highlighter'
require 'redcloth'

class Article
  
  attr_accessor :title, :guid, :body, :published_at, :tags, :comments, :trackbacks
  
  def initialize(attributes)
    attributes.each do |attribute, value|
      __send__("#{attribute}=", value)
    end
  end
  
  class << self
    def find_all
      @articles ||= (
        articles_dir = File.join(File.dirname(__FILE__), *%w[.. .. articles])
        Dir[File.join(articles_dir, '*.yml')].collect do |article_filename|
          article_attributes = YAML.load_file(article_filename)
          article_attributes[:tags] = (article_attributes.delete(:tags) || []).collect { |tag_name| 
            Tag.new(:name => tag_name) 
          }
          article_attributes[:comments] = (article_attributes.delete(:comments)||[]).collect { |comment_attributes|
            Comment.new(comment_attributes)
          }
          article_attributes[:trackbacks] = (article_attributes.delete(:trackbacks)||[]).collect { |trackback_attributes|
            Trackback.new(trackback_attributes)
          }
          Article.new(article_attributes)
        end.sort do |article_a, article_b| # Sort in descending order of published_at
          article_b.published_at <=> article_a.published_at
        end
      )
    end
    def years_published
      find_all.collect { |article| article.published_at.year }.uniq
    end
    def months_and_years_published
      find_all.collect { |article| [article.published_at.month, article.published_at.year] }.uniq
    end
    def days_months_and_years_published
      find_all.collect { |article| [article.published_at.day, article.published_at.month, article.published_at.year] }.uniq
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