class BlogSweeper < ActionController::Caching::Sweeper
  observe Article, Comment, Trackback, Page, Blog, User

  def after_save(record)
    expire_for(record)
  end

  def after_destroy(record)
    expire_for(record)
  end

  def expire_for(record)
    case record
    when Blog, Comment, Trackback, Article, User
      PageCache.sweep_all
      expire_fragment(/.*/)
    when Page
      PageCache.sweep("/pages/#{record.name}.html")
      expire_fragment(/.*\/pages\/.*/)
      expire_fragment(/.*\/view_page.*/)
    end
  end
end