class Year
  
  def self.find_all
    Article.years_published.collect { |year| new(year) }
  end
  
  attr_reader :year
  
  def initialize(year)
    @year = year
    @published_date = Date.new(year.to_i, 1, 1)
  end
  
  def articles
    @articles ||= Article.find_all_published_during(@year)
  end
  
  def path
    File.join(ARTICLES_URL_ROOT, @year)
  end
  
  def url
    File.join(path, 'index')
  end
  
  def page_title
    "Posts published in #{@published_date.strftime("%Y")}"
  end
  
end