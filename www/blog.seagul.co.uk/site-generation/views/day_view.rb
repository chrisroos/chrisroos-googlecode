class DayView < ArticlesView
  def page_title
    "Posts published on #{@articles_container.published_date.strftime("%a, %d %B %Y")}"
  end
  def robots_meta_tag
    %%<meta name="robots" content="noindex" />%
  end
end
