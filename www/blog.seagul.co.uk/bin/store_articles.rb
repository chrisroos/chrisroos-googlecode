#! /usr/bin/env ruby

require File.join(File.dirname(__FILE__), '..', 'config', 'environment')
require 'article'

articles_path = File.join(File.dirname(__FILE__), *%w[.. articles])
Dir[File.join(articles_path, '*.yml')].each do |article_file|
  article_attributes = YAML.load_file(article_file)
  if Article.find_by_title(article_attributes[:title])
    p "Article ('#{article_attributes[:title]}') already exists, skipping"
  else
    Article.create!(article_attributes)
    p "Article ('#{article_attributes[:title]}') created"
  end
end