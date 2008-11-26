require 'comment'
require 'trackback'
require 'syntax_highlighter'
gem 'RedCloth', '3.0.4' # I'm not sure why, but 4.x versions of RedCloth result in my typo_code being html escaped
require 'redcloth'

class Article
  
  attr_accessor :title, :guid, :body, :published_at, :comments, :trackbacks
  
  def initialize(attributes)
    attributes.each do |attribute, value|
      __send__("#{attribute}=", value)
    end
  end
  
  class << self
    def find_all
      @articles ||= (
        articles_dir = File.join(File.dirname(__FILE__), *%w[.. .. content articles])
        Dir[File.join(articles_dir, '*.yml')].collect do |article_filename|
          article_attributes = YAML.load_file(article_filename)
          article_attributes.delete(:tags)
          article_attributes[:comments] = (article_attributes.delete(:comments)||[]).collect { |comment_attributes|
            Comment.new(comment_attributes)
          }
          article_attributes[:trackbacks] = (article_attributes.delete(:trackbacks)||[]).collect { |trackback_attributes|
            [:published, :ip, :article_id].each { |key| trackback_attributes.delete(key) }
            Trackback.new(trackback_attributes)
          }
          Article.new(article_attributes)
        end.sort do |article_a, article_b| # Sort in descending order of published_at
          article_b.published_at <=> article_a.published_at
        end
      )
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
    ARTICLES_URL_ROOT
  end
  
  def url
    # Representation agnostic (i.e. doesn't specify .html, .xml)
    File.join(path, "#{published_at.to_date}-#{permalink}")
  end
  
  public :binding
  
end
