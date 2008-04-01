class Day
  
  def self.find_all
    Article.days_months_and_years_published.collect { |day, month, year| new(day, month, year) }
  end
  
  attr_reader :day, :month, :year, :published_date, :articles
  
  def initialize(day, month, year, articles = Article.find_all)
    @day, @month, @year = format("%02d", day), format("%02d", month), year.to_s
    @published_date = Date.new(year.to_i, month.to_i, day.to_i)
    @articles = articles.select { |article|
      article.published_at.day == day && article.published_at.month == month && article.published_at.year == year
    }
  end
  
  def path
    File.join(ARTICLES_URL_ROOT, @year, @month, @day)
  end
  
  def url
    File.join(path, 'index')
  end
  
end