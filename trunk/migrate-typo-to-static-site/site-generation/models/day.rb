class Day
  
  def self.find_all
    Article.days_months_and_years_published.collect { |day, month, year| new(day, month, year) }
  end
  
  attr_reader :day, :month, :year
  
  def initialize(day, month, year)
    @day, @month, @year = format("%02d", day), format("%02d", month), year
    @published_date = Date.new(year.to_i, month.to_i, day.to_i)
  end
  
  def articles
    @articles ||= Article.find_all_published_during(@year, @month, @day)
  end
  
  def path
    File.join(ARTICLES_URL_ROOT, @year, @month, @day)
  end
  
  def url
    File.join(path, 'index')
  end
  
  def page_title
    "Posts published on #{@published_date.strftime("%a, %d %B %Y")}"
  end
  
end