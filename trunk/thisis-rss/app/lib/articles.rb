require File.join(File.dirname(__FILE__), 'yaml_serializer')
require File.join(File.dirname(__FILE__), 'yaml_deserializer')

class Articles

  class << self
    def retrieve(io, deserializer)
      new deserializer.deserialize(io.read)
    end
    def retrieve_from_yaml_file(filename)
      File.open(filename) { |file| retrieve(file, YamlDeserializer.new) }
    end
  end
  
  def initialize(articles = [])
    @articles = articles
  end
  
  def each(&blk)
    sorted_articles.each(&blk)
  end
  
  def add(article)
    if article_exists?(article)
      false
    else
      @articles << article
    end
  end
  
  def length
    @articles.length
  end
  
  def store(io, serializer)
    io.puts(serializer.serialize(@articles))
  end
  
  def store_to_yaml_file(filename)
    File.open(filename, 'w') { |file| store(file, YamlSerializer.new) }
  end
  
private
  
  def sorted_articles
    @articles.sort { |article_1, article_2| article_2[:id] <=> article_1[:id] }
  end
  
  def article_exists?(article)
    @articles.find { |a| a[:id] == article[:id] }
  end
  
end