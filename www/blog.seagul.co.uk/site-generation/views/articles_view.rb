class ArticlesView
  def initialize(articles_container)
    @articles_container = articles_container
  end
  def path
    @articles_container.path
  end
  def url
    @articles_container.url
  end
  def articles
    @articles_container.articles
  end
  def robots_meta_tag
  end
  public :binding
end
