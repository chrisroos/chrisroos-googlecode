class Article
  public :binding
  attr_reader :paper, :title, :author, :page_number, :other_attributes
  def initialize(paper, title, author, page_number, other_attributes)
    @paper, @title, @author, @page_number, @other_attributes = paper, title, author, Integer(page_number), other_attributes
    @paper.add_article(self)
  end
  def html_title
    "#{self.title} - #{paper.html_title}"
  end
  def iso8601_published_date
    paper.iso8601_date
  end
  def human_friendly_published_date
    paper.human_friendly_date
  end
  def paper_name
    paper.title
  end
  def url_friendly_title
    title.downcase.gsub(/ /, '-').gsub(/[^a-zA-Z0-9-]/, '').squeeze('-')
  end  
end