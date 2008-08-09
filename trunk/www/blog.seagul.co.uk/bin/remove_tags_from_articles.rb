require 'yaml'

articles_path = File.join(File.dirname(__FILE__), '..', 'content', 'articles')

Dir[File.join(articles_path, '*.yml')].each do |article_path|
  article = YAML.load(File.read(article_path))
  article.delete(:tags)
  File.open(article_path, 'w') { |f| f.puts(article.to_yaml) }
end
