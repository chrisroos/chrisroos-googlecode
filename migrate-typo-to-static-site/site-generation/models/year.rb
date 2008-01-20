class Year
  
  def self.find_all
    Article.years_published.collect { |year| Year.new(year) }
  end
  
  attr_reader :year
  
  def initialize(year)
    @year = year
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
  
end