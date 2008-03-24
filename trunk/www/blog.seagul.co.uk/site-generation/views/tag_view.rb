class TagView < ArticlesView
  def page_title
    "Posts tagged #{@articles_container.name}"
  end
end