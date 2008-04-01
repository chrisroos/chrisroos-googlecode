require File.join(File.dirname(__FILE__), *%w[.. config environment])
require 'article'

Article.find(:all).each do |article|
  article_attributes = article.attributes.symbolize_keys
  article_attributes.delete(:id)
  article_attributes[:tags] = article.tags.collect { |tag| tag.name }
  article_attributes[:comments] = article.comments.collect { |comment|
    comment_attributes = comment.attributes.symbolize_keys
    comment_attributes.delete(:id)
    comment_attributes
  }
  published_at_for_filename = article_attributes[:published_at].strftime("%Y-%m-%d")
  filename = "#{published_at_for_filename}-#{article.permalink}.yml"
  filepath = File.join(File.dirname(__FILE__), '..', 'articles', filename)

  if File.exists?(filepath)
    warn "WARNING: Cannot overwrite existing article called: #{filename}"
  else
    File.open(filepath, 'w') { |f| f.puts(article_attributes.to_yaml) }
    puts "Created article: #{filename}"
  end
  
end