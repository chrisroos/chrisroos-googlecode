class DayView < ArticlesView
  def page_title
    "Posts published on #{@articles_container.published_date.strftime("%a, %d %B %Y")}"
  end
end