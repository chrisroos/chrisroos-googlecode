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
  def previous_post
    @article.previous_article
  end
  def next_post
    @article.next_article
  end
  public :binding
end
