class ArticleView
  def initialize(article)
    @article = article
  end
  def path
    @article.path
  end
  def url
    @article.url
  end
  def page_title
    @article.title
  end
  def formatted_published_date
    @article.formatted_published_date
  end
  def body_html
    @article.body_html
  end
  def tags
    @article.tags
  end
  def comments
    @article.comments
  end
  public :binding
end