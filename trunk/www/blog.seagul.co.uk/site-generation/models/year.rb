class Year
  
  def self.find_all
    Article.years_published.collect { |year| new(year) }
  end
  
  attr_reader :year, :published_date, :articles
  
  def initialize(year, articles = Article.find_all)
    @year = year.to_s
    @published_date = Date.new(year.to_i, 1, 1)
    @articles = articles.select { |article| 
      article.published_at.year == year
    }
  end
  
  def path
    File.join(ARTICLES_URL_ROOT, @year)
  end
  
  def url
    File.join(path, 'index')
  end
  
end