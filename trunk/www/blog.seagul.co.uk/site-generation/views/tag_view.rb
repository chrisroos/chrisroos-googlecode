class TagView < ArticlesView
  def page_title
    "Posts tagged #{@articles_container.name}"
  end
  def robots_meta_tag
    %%<meta name="robots" content="noindex" />%
  end
end
