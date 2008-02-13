require 'yaml'

class YamlSerializer
  def serialize(articles)
    articles.to_yaml
  end
end