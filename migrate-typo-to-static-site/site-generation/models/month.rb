class Month
  
  def self.find_all
    Article.months_and_years_published.collect { |month, year| new(month, year) }
  end
  
  attr_reader :month, :year, :published_date
  
  def initialize(month, year)
    @month, @year = format("%02d", month), year
    @published_date = Date.new(year.to_i, month.to_i, 1)
  end
  
  def articles
    @articles ||= Article.find_all_published_during(@year, @month)
  end
  
  def path
    File.join(ARTICLES_URL_ROOT, @year, @month)
  end
  
  def url
    File.join(path, 'index')
  end
  
end