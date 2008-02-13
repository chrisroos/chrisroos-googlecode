class ArticlesView
  
  def initialize(articles, number_to_display)
    @articles, @number_to_display = articles, number_to_display
  end
  
  def each_article
    number_displayed = 0
    @articles.each do |article|
      break if number_displayed == @number_to_display
      yield article
      number_displayed += 1
    end
  end
  
  public :binding
  
end