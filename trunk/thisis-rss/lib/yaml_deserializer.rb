require 'yaml'

class YamlDeserializer
  def deserialize(serialized_articles)
    deserialized_articles = YAML.load(serialized_articles)
    deserialized_articles ? deserialized_articles : []
  end
end