class Month
  
  def self.find_all
    Article.months_and_years_published.collect { |month, year| new(month, year) }
  end
  
  attr_reader :month, :year, :published_date, :articles
  
  def initialize(month, year, articles = Article.find_all)
    @month, @year = format("%02d", month), year.to_s
    @published_date = Date.new(year.to_i, month.to_i, 1)
    @articles = articles.select { |article| 
      article.published_at.month == month && article.published_at.year == year
    }
  end
  
  def path
    File.join(ARTICLES_URL_ROOT, @year, @month)
  end
  
  def url
    File.join(path, 'index')
  end
  
end