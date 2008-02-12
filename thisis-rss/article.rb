class Article
  attr_reader :id, :date, :headline, :content, :url
  def initialize(id, date, headline, content, url)
    @id, @date, @headline, @content, @url = id, date, headline, content, url
  end
end