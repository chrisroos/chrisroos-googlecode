class MonthView < ArticlesView
  def page_title
    "Posts published in #{@articles_container.published_date.strftime("%B %Y")}"
  end
end