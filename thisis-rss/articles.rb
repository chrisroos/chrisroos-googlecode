require 'yaml_serializer'
require 'yaml_deserializer'

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
    @articles.each(&blk)
  end
  
  def add(article)
    @articles << article unless article_exists?(article)
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
  
  def article_exists?(article)
    @articles.find { |a| a[:id] == article[:id] }
  end
  
end