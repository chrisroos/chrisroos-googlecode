class Trackback
  
  attr_accessor :published_at, :blog_name, :url, :excerpt, :title
  
  def initialize(attributes)
    attributes.each do |attribute, value|
      __send__("#{attribute}=", value)
    end
  end
  
  def formatted_published_date
    published_at.strftime("%a, %d %b %Y %H:%M:%S")
  end
  
end