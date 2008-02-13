require 'test/unit'
require 'lib/yaml_deserializer'

class YamlDeserializerTest < Test::Unit::TestCase
  
  def test_should_deserialize_the_yaml_representation_of_the_articles
    yaml_articles = [].to_yaml
    deserializer = YamlDeserializer.new
    assert_equal [], deserializer.deserialize(yaml_articles)
  end
  
  def test_should_return_an_empty_array_if_the_serialized_articles_are_just_an_empty_string
    yaml_articles = ''
    deserializer = YamlDeserializer.new
    assert_equal [], deserializer.deserialize(yaml_articles)
  end
  
end