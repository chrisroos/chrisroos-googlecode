class YearView < ArticlesView
  def page_title
    "Posts published in #{@articles_container.published_date.strftime("%Y")}"
  end
end