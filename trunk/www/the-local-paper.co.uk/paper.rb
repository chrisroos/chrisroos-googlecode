class Paper
  public :binding
  attr_reader :title, :date, :articles
  def initialize(title, date)
    @title, @date = title, date
    @articles, @articles_by_page_number = [], {}
  end
  def add_article(article)
    @articles << article
    @articles_by_page_number[article.page_number] ||= []
    @articles_by_page_number[article.page_number] << article
  end
  def each_page_with_articles
    @articles_by_page_number.sort { |(p1, a1), (p2, a2)| p1 <=> p2 }.each { |page_number, articles| yield page_number, articles }
  end
  def html_title
    "#{self.title} on #{self.human_friendly_date}"
  end
  def human_friendly_date
    self.date.strftime("%A %d %b %Y")
  end
  def iso8601_date
    self.date.iso8601
  end
  def url_friendly_title
    title.downcase.gsub(/ /, '-')
  end
end