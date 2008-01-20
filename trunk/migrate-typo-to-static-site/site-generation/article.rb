require File.join(MIGRATOR_ROOT, 'environment')
require File.join(MIGRATOR_ROOT, 'comment')
require File.join(MIGRATOR_ROOT, 'trackback')
require File.join(MIGRATOR_ROOT, 'tag')
require File.join(MIGRATOR_ROOT, 'syntax_highlighter')
require 'redcloth'

class Article < ActiveRecord::Base
  
  has_many :comments, :dependent => :destroy, :order => 'created_at ASC', :conditions => 'published = TRUE'
  has_many :trackbacks, :dependent => :destroy, :order => 'created_at ASC'
  has_and_belongs_to_many :tags, :foreign_key => 'article_id'
  
  def formatted_published_date
    published_at.strftime("%a, %d %b %Y %H:%M:%S")
  end
  
  def body_html
    body = self.body.gsub(/<typo:code(.*?)>(.*?)<\/typo:code>/m) do
      code = $2
      lang = $1[/lang="(.*?)"/, 1]
      SyntaxHighlighter.markup_code(code, lang)
    end
    RedCloth.new(body).to_html(:textile)
  end
  
  public :binding
  
end