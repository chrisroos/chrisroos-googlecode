# Useful data from discarded tables
# * Ping URLs
# http://rpc.technorati.com/rpc/ping
# http://ping.blo.gs/
# http://rpc.weblogs.com/RPC2
# * Subscribe to RSS in sidebar snippet
# <a href="http://feeds.feedburner.com/DeferredUntilInspirationHits" title="Subscribe to my feed, deferred until inspiration hits" rel="alternate" type="application/rss+xml">
# <img src="http://www.feedburner.com/fb/images/pub/feed-icon16x16.png" alt="" style="border:0"/> 
# Subscribe to the feed
# </a>

require 'active_record'

ActiveRecord::Base.establish_connection({
  :adapter => 'mysql',
  :host => 'localhost',
  :database => 'blog_seagul_co_uk',
  :user => 'root'
})

class Time
  public :to_date
end

require 'syntax/convertors/html'

class SyntaxHighlighter
  def self.markup_code(code = '', lang = 'default')
    cssclass = nil
    linenumber = nil
    title = nil

    code = code.to_s.gsub(/\r/,'').gsub(/\A\n/,'').chomp

    convertor = Syntax::Convertors::HTML.for_syntax lang
    code = convertor.convert(code)
    code.gsub!(/<pre>/,"<pre><code class=\"typocode_#{lang} #{cssclass}\"><notextile>")
    code.gsub!(/<\/pre>/,"</notextile></code></pre>")

    if(linenumber)
      lines = code.split(/\n/).size
      linenumbers = (1..lines).to_a.collect{|line| line.to_s}.join("\n")

      code = "<table class=\"typocode_linenumber\"><tr><td class=\"lineno\">\n<pre>\n#{linenumbers}\n</pre>\n</td><td width=\"100%\">#{code}</td></tr></table>"
    end

    if(title)
      titlecode="<div class=\"codetitle\">#{title}</div>"
    else
      titlecode=''
    end

    "<div class=\"typocode\">#{titlecode}#{code}</div>"
  end
end

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
class Tag < ActiveRecord::Base
  has_and_belongs_to_many :articles, :order => 'created_at DESC'
  public :binding
end
class Trackback < ActiveRecord::Base
  belongs_to :article
end
class Comment < ActiveRecord::Base
  belongs_to :article
  def body_html
    RedCloth.new(body).to_html(:textile)
  end
  def formatted_created_date
    created_at.strftime("%a, %d %b %Y %H:%M:%S")
  end
end
class Page < ActiveRecord::Base; end

# Article.find(:all).each do |article|
#   
#   year, month, day = article.created_at.to_date.to_s.split('-')
#   article_path = File.join('Site', 'articles', year, month, day)
#   require 'fileutils'
#   FileUtils.mkdir_p(article_path)
# 
#   require 'erb'
#   include ERB::Util
# 
#   article_template = File.open('article.erb.html') { |f| f.read }
#   article_erb = ERB.new(article_template)
#   File.open(File.join(article_path, "#{article.permalink}.html"), 'w') do |file|
#     file.puts article_erb.result(article.binding)
#   end
#   
# end

Tag.find(:all).each do |tag|
  tag_path = File.join('Site', 'articles', 'tag')
  require 'fileutils'
  FileUtils.mkdir_p(tag_path)
  
  require 'erb'
  include ERB::Util

  tag_template = File.open('tag.erb.html') { |f| f.read }
  tag_erb = ERB.new(tag_template)
  File.open(File.join(tag_path, "#{tag.name}.html"), 'w') do |file|
    file.puts tag_erb.result(tag.binding)
  end
end