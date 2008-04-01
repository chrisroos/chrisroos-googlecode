class Tag
  
  def self.find_all
    @tags ||= (
      tags = Hash.new { |hash, key| hash[key] = [] }
      Article.find_all.each do |article|
        article.tags.each { |tag| tags[tag.name] << article }
      end
      tags.collect do |tag, articles|
        new(:name => tag, :articles => articles)
      end
    )
  end
  
  attr_accessor :name, :articles
  
  def initialize(attributes)
    attributes.each do |attribute, value|
      __send__("#{attribute}=", value)
    end
  end
  
  def path
    TAGS_URL_ROOT
  end
  
  def url
    # Representation agnostic (i.e. doesn't specify .html, .xml)
    File.join(path, name)
  end
  
  public :binding
  
end