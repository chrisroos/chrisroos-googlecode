require 'redcloth'

class Comment
  
  attr_accessor :body, :url, :author, :published_at, :article_id
  
  def initialize(attributes)
    attributes.each do |attribute, value|
      __send__("#{attribute}=", value)
    end
  end
  
  def body_html
    RedCloth.new(body).to_html(:textile)
  end
  
  def formatted_published_date
    published_at.strftime("%a, %d %b %Y %H:%M:%S")
  end
  
end