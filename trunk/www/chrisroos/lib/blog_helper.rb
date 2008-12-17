module BlogHelper
  def blog_posts(number = :all, options = {}, &blk)
    defaults = {:in_directory => "blog", :sort_by => "created_at", :reverse => true, :blog_post => true}
    @pages.find(number, defaults.merge(options), &blk)
  end
end

Webby::Helpers.register(BlogHelper)