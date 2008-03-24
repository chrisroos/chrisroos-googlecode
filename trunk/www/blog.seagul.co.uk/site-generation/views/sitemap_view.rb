class SitemapView
  def initialize(articles)
    @articles = articles
  end
  def path
    File.join('/')
  end
  def url
    File.join(path, 'sitemap')
  end
  def articles
    @articles
  end
  public :binding
end