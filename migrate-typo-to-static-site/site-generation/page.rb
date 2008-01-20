require File.join(MIGRATOR_ROOT, 'environment')

class Page < ActiveRecord::Base
  
  def formatted_created_date
    created_at.strftime("%a, %d %b %Y %H:%M:%S")
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
    PAGES_ROOT
  end
  
  def url
    File.join(path, name)
  end
  
  public :binding
  
end