require 'hpricot'

class DocumentParser
  
  def self.from_file(filename)
    html = File.open(filename) { |f| f.read }
    doc = Hpricot(html)
    new(doc)
  end
  
  BASE_URL = 'http://www.thisiskent.co.uk'
  
  def initialize(hpricot_doc)
    @hpricot_doc = hpricot_doc
  end
  
  def each_article_attributes
    (@hpricot_doc/'div.newsListingMainDivWidth').each do |element|
      element_parser = ArticleElementParser.new(element)
      article_attributes = {
        :id => element_parser.id,
        :date => element_parser.date,
        :headline => element_parser.headline,
        :content => element_parser.content,
        :url => element_parser.url
      }
      yield article_attributes
    end
  end
  
  class ArticleElementParser
    
    def initialize(hpricot_element)
      @hpricot_element = hpricot_element
      @content_container = (@hpricot_element/'p.ptag')
      (@content_container/'a').remove # Remove the more link from the content paragraph
      @date_container = (@content_container/'i').remove
    end
    
    def url
      relative_url = (@hpricot_element/'a.lbblue').first.attributes['href']
      File.join(BASE_URL, relative_url)
    end
    
    def id
      uri = URI.parse(url)
      id = uri.query.split('&').collect { |key_and_value| key_and_value.split('=') }.select { |key, value| key == 'contentPK' }.flatten.last
    end
    
    def headline
      headline = (@hpricot_element/'a.lbblue').first.innerText
      tidy_text(headline)
    end
    
    def date
      date = @date_container.first.innerText
      day, month = date.split(' ')
      Time.parse("#{day}-#{month}-2008")
    end
    
    def content
      content = @content_container.first.innerText
      content = tidy_text(content)
      content.sub(/^: /, '') # Remove the colon that was there to separate the date from the content
    end
    
  private
  
    def tidy_text(text)
      text.gsub(/\r|\t|\n/, '')
    end
    
  end
  
end