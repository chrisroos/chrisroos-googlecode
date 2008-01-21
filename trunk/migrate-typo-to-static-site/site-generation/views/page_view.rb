class PageView
  def initialize(page)
    @page = page
  end
  def path
    @page.path
  end
  def url
    @page.url
  end
  def page_title
    @page.title
  end
  def formatted_created_date
    @page.formatted_created_date
  end
  def body_html
    @page.body_html
  end
  public :binding
end