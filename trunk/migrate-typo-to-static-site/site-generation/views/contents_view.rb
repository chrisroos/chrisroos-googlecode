class ContentsView
  attr_reader :articles
  def initialize(articles)
    @articles = articles
  end
  def path
    '/'
  end
  def url
    File.join(path, 'contents')
  end
  def page_title
    "All articles..."
  end
  public :binding
end