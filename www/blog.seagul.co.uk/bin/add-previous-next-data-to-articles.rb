article_dir = File.join(File.dirname(__FILE__), 'content', 'articles')
article_filenames = Dir[File.join(article_dir, '*.yml')].collect { |article_filename| File.basename(article_filename) }

require 'yaml'

article_filenames.each_with_index do |article_filename, index|
  article = YAML.load(File.read(File.join(article_dir, article_filename)))

  unless index == 0 # we're at the first article
    previous_article = article_filenames[index - 1]
    article[:previous] = previous_article
  end
  
  unless index == (article_filenames.length - 1)
    next_article = article_filenames[index + 1] 
    article[:next] = next_article
  end

  File.open(File.join(article_dir, article_filename), 'w') { |f| f.puts(article.to_yaml) }
end
