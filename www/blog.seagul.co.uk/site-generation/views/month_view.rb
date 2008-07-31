class MonthView < ArticlesView
  def page_title
    "Posts published in #{@articles_container.published_date.strftime("%B %Y")}"
  end
  def robots_meta_tag
    %%<meta name="robots" content="noindex" />%
  end
end
