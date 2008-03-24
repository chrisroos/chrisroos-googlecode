class LatestArticlesXmlView
  def initialize(latest_articles)
    @latest_articles = latest_articles
  end
  def path
    File.join('/', 'xml')
  end
  def url
    File.join(path, 'rss')
  end
  def articles
    @latest_articles
  end
  def page_title
    "Most recent posts"
  end
  public :binding
end