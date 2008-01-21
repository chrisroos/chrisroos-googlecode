class TagView < ArticlesView
  def page_title
    "Posts tagged #{@articles_container.display_name}"
  end
end